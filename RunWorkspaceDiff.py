# ---------------------------------------------------------------------------
# Workspace geodatabase xml compare
# ---------------------------------------------------------------------------
#
# xml libs (libxml2 and libxslt) from http://www.lfd.uci.edu/~gohlke/pythonlibs/
#
import argparse, os, sys
import errno, subprocess
import libxml2
import libxslt

'''
From http://jimmyg.org/blog/2009/working-with-python-subprocess.html
'''
def whereis(program):
    for path in os.environ.get('PATH', '').split(':'):
        if os.path.exists(os.path.join(path, program)) and \
           not os.path.isdir(os.path.join(path, program)):
            return os.path.join(path, program)
    return None

def safeCreateDir(directory):
    if (directory is None or len(directory) == 0):
        #no directory was provided. Use the current dir
        return os.getcwd()
    #try and make it if it doesn't exist
    try:
        os.makedirs(directory)
    except OSError as e:
        #is it because it already exists?
        if e.errno != errno.EEXIST:
            raise
    return directory

parser = argparse.ArgumentParser(description='Run the batch job report')


parser.add_argument('-gdb_xml1', action="store", dest="wks1", 
                    default="")
parser.add_argument('-gdb_xml2', action="store", dest="wks2", 
                    default="")

parser.add_argument('-diff', action="store", dest="diff", 
                    default="C:\\Program Files (x86)\\Microsoft SDKs\\Windows\\v7.0A\\Bin\\windiff.exe")

args = parser.parse_args()

#check our xslt exists
xslt = "filter_wks3.xsl"
if (not os.path.exists(xslt)):
    #exit
    sys.stdout.write ( "Unable to find xslt '" + xslt + "'." )
    sys.exit()

#make sure we have a diff
if (len(args.diff) == 0): args.diff = "windiff.exe"

diff = args.diff

if (not os.path.exists(diff)):
    diff = whereis(os.path.basename(diff))
    if (diff == None):
        #warn the user - we can't find his/her diff program
        print "Warning: Could not find %r.\n" % args.diff
        print "Add the location to your PATH or specify the full path"
        print "on the command line using the '-diff' argument if you"
        print "would like to run a 'diff' on the output results\n"
        
styledoc = libxml2.parseFile(xslt)
style = libxslt.parseStylesheetDoc(styledoc)

#create our output folder
output = "" #put your output folder here, otherwise the 'cwd' will be used
OutputFolder = safeCreateDir(output)

outputs = []
for xml in (args.wks1, args.wks2) :
    print "Processing %r..." % xml
    if (not os.path.exists(args.wks1)):
        print "File %r does not exist, %r" % (xml, os.getcwd())
    else:
        #process
        try:
            wksDom = libxml2.parseFile(xml)
            result = style.applyStylesheet(wksDom, None)
            resultFileName = os.path.join(OutputFolder,os.path.splitext(os.path.basename(xml))[0]) + ".txt"
            print "Saving result to %r" % resultFileName
            if (os.path.isfile(resultFileName)):
                try:
                    os.remove(resultFileName)
                except:
                    pass #a new version will simply be created
            style.saveResultToFilename(resultFileName, result, 0)
            outputs.append(resultFileName.replace("\\","/"))
            wksDom.freeDoc()
            result.freeDoc()
        except libxml2.parserError as pe:
            print "Parse error %r for %r" % (pe.msg, xml)
        except:
            print "Unknown error parsing %r" % xml
    
style.freeStylesheet()

sys.stdout.write( "Results written to '" + OutputFolder + "'\n")
#print "Count: %d" % outputs.count
if (len(outputs)):
    #try and do the diff
    try:
        if (not diff == None):
            os.system('\"\"%s\" \"%s\" \"%s\"\"' % (diff, outputs[0], outputs[1]))
        else:
            #show the files
            os.system('\"\"%s\"\"' % outputs[0])
            os.system('\"\"%s\"\"' % outputs[1])
    except OSError as e:
        print "Exception executing %r: %r" % (diff, e)
        os.system('\"\"%s\"\"' % outputs[0])
        os.system('\"\"%s\"\"' % outputs[1])
elif (len(outputs) == 1):
    #just show the file
    try:
        os.system('\"\"%s\"\"' % outputs[0])
        #subprocess.Popen([outputs[0]],shell=True)
    except OSError as e:
        print "Exception opening %r for display: %r" % (os.path.basename(outputs[0]), e.message)

sys.stdout.write ( "Execution complete..." )