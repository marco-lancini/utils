import os
import zipfile

def zipdir(path, ziph):
    for root, dirs, files in os.walk(path):
        for file in files:
            ziph.write(os.path.join(root, file),
                       os.path.relpath(os.path.join(root, file),
                                       os.path.join(path, '..')))


def do_zip(directory, fname):
    zipf = zipfile.ZipFile(fname, 'w', zipfile.ZIP_DEFLATED)
    zipdir(directory, zipf)
    zipf.close()
