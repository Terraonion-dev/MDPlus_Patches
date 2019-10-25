using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TOPatcher
{
	class Program
	{
		static byte[] GetByteString(string bytestring)
		{
			if ((bytestring.Length & 1) != 0)
				throw new ArgumentException("Patch string must have an even number of characters");

			byte[] b = new byte[bytestring.Length / 2];
			for (int l = 0; l < b.Length; ++l)
			{
				b[l] = byte.Parse(bytestring.Substring(2 * l, 2),System.Globalization.NumberStyles.HexNumber);
			}

			return b;
		}

		static void Main(string[] args)
		{
			if (args.Count() != 3)
			{
				Console.WriteLine("Usage");
				Console.WriteLine("TOPatcher <patchfile> <originalfile> <destinationfile>");
				return;
			}
			string infile = args[1];
			string outfile = args[2];
			string patchfile = args[0];

			Console.WriteLine("Reading File " + infile);
			byte[] filedata = File.ReadAllBytes(infile);

			bool success = true;


			Console.WriteLine("Appling patches from " + patchfile);
			StreamReader sr = new StreamReader(patchfile, false);
			while (!sr.EndOfStream)
			{
				string line = sr.ReadLine();

				line = line.Trim();

				if (line.StartsWith("@"))	//process a patch 
				{
					string[] tokens = line.Split(' ');

					if (tokens.Count() >= 2)
					{
						if (tokens[2] == "->")  //patch data
						{
							uint address = uint.Parse(tokens[0].Substring(1), System.Globalization.NumberStyles.HexNumber);
							byte[] original = GetByteString(tokens[1]);
							byte[] patch = GetByteString(tokens[3]);

							bool originalmatch = true;
							bool patchmatch = true;

							if (original.Length != patch.Length)
								throw new ArgumentException("Original and patch strings must be the same length");

							for (int i = 0; i < original.Length; ++i)
							{
								if (filedata[address + i] != original[i])
								{
									originalmatch = false;
									break;
								}
							}

							for (int i = 0; i < patch.Length; ++i)
							{
								if (filedata[address + i] != patch[i])
								{
									patchmatch = false;
									break;
								}
							}

							Console.WriteLine("Patching address " + address.ToString("X8"));

							if (originalmatch)
							{
								for (int i = 0; i < original.Length; ++i)
								{
									filedata[address + i] = patch[i];
								}
							}
							else if (patchmatch)
							{
								Console.WriteLine("Patch already applied, skipping");
							}
							else
							{
								Console.WriteLine("Original file doesn't match the expected values");
								success = false;
								break;
							}
						}
						else if (tokens[1].Equals("Inject", StringComparison.InvariantCultureIgnoreCase))
						{
							uint address = uint.Parse(tokens[0].Substring(1), System.Globalization.NumberStyles.HexNumber);
							byte[] injectdata = File.ReadAllBytes(tokens[2]);

							if (address + injectdata.Length > filedata.Length)
								throw new ArgumentException("Insuficient space to inject the file");

							for (int i = 0; i < injectdata.Length; ++i)
								filedata[address + i] = injectdata[i];
						}
					}
				}
			}

			if (success)
			{
				Console.WriteLine("Writting File " + outfile);
				File.WriteAllBytes(outfile, filedata);
			}
		}
	}
}
