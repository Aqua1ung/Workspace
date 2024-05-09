import os

# walk the directory tree (a "generator" object)
for root, dirs, files in os.walk("C:/Users/crist/Google Drive/PortableApps/PortableApps/", topdown=False):
    # for each filename, delete those files whose name contains "[Conflict" or "corrupt"
    for name in files:
        if ("[Conflict" in name) or ("corrupt" in name): os.remove(os.path.join(root, name))