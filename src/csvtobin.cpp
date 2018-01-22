#include <iostream>
#include <nnlib/serialization/binaryserializer.hpp>
#include <nnlib/serialization/csvserializer.hpp>
#include <nnlib/util/args.hpp>
using namespace nnlib;
using namespace std;

int main(int argc, const char **argv)
{
    ArgsParser args;
    args.addString('d', "delimiter", ",");
    args.addInt('s', "skipLines", 0);
    args.addFlag('v', "verbose");
    args.addString();
    args.addString();

    try
    {
        args.parse(argc, argv);
    }
    catch(const Error &)
    {
        clog << "Usage: csvtobin [options] [infile] [outfile]" << endl;
        args.printHelp();
        return 1;
    }

    char delimiter = args.getString("delimiter")[0];
    size_t skipLines = args.getInt("skipLines");
    bool verbose = args.getFlag("verbose");
    string infile = args.getString(0);
    string outfile = args.getString(1);

    if(verbose)
        clog << "Converting " << infile << " to " << outfile << "..." << flush;

    try
    {
        BinarySerializer::write(CSVSerializer::read(infile, skipLines, delimiter), outfile);
    }
    catch(const Error &e)
    {
        if(verbose)
            cerr << endl;
        cerr << "Unable to convert! " << e.what() << endl;
        exit(1);
    }

    if(verbose)
        clog << " Done!" << endl;

    return 0;
}
