import pandas as pd
import os.path as op
import os
import json
import time
import sys
import glob

# read file into dataframe.csv
def filetodf(readFolder, readFile, dataframeName="dataframe.csv"):
    # max character length of each entry
    max_length = 20000
    if readFolder == "":
        filePath = readFile
    elif readFolder[-1] != "\\":
        filePath = readFolder + "\\" + readFile
    else:
        filePath = readFolder + readFile
    outFileName = dataframeName

    # open read file
    fd = open(filePath, encoding='utf-8', errors="ignore")
    # read text
    text = fd.readlines()
    text = "".join(text)
    # divide text every 20k characters
    parts = len(text) // (max_length) + (1 if len(text) % max_length > 0 else 0)

    # print(parts)
    
    for part in range(parts):
        start_index = part * max_length
        end_index = start_index + max_length

        newStructure = {'text' : [text[start_index:end_index]]}
        loading(part + 1, parts)

        tempdf = pd.DataFrame(newStructure)
        if os.path.exists(outFileName):
            tempdf.to_csv("temp_df.csv", index=False)
            chunk_size = 1000
            for chunk in pd.read_csv('temp_df.csv', chunksize=chunk_size):
                chunk.to_csv(outFileName, mode='a', header=False, index=False)
        else:
            tempdf.to_csv(outFileName, index=False)

    print(f"\nUpdated {outFileName} with file {readFile}.\n\n")
    return

# delete the dataframe
def deletedf(dfName="dataframe.csv"):
    open(dfName, "w")
    os.remove(dfName)
    print("\nDataframe cleared...")
    return

def parseJSON(nameJSON, dfName="dataframe.csv"):
    # read dataframe
    df_code = pd.read_csv(dfName)
    # open output .json (this is the code from Shailja)
    print("Making JSON...")
    total_rows = len(df_code['text'].values)
    index = 0
    with open(nameJSON,'a') as f:
        for row in df_code['text'].values:
            #print("Adding row...")
            # adds dictionary
            dic={"text":str(row)}
            ob=json.dumps(dic)
            f.write(ob)
            f.write('\n')
            loading(index+1, total_rows)
            index += 1
            
    f.close()
    print(f"\n\nJSON Complete : written to {os.path.dirname(f'{nameJSON}.json')+nameJSON}...")
    # clear dataframe after use
    deleteit = input("Would you like to delete the old dataframe now?\n.\n.\n.\n(Y/N) >> ")
    if deleteit == "Y" or deleteit == "y":
        deletedf(dfName)
    
    return

# gui loading animation
def loading(current, total, length=30):
    progress = current / total
    bar_length = int(length * progress)
    bar = "[" + "#" * bar_length + "-" * (length - bar_length) + "]"
    # Display the progress bar with percentage
    sys.stdout.write(f"\r{bar} {int(progress * 100)}%")
    sys.stdout.flush()

# start builder
print("\n.\n.\n.\n**************\n**** HOME ****\n**************\n\nWelcome to the dataset builder")
while True:
    uin = input("What would you like to do?\nc : clear dataframe\na : create/add to dataframe (dataframe builder)\nmds : make dataset from existing dataframe\nhelp : info about this script\nq : quit builder\n.\n.\n.\n>> ")
    if uin == "Q" or uin == "q":

        print("exiting...\n")
        exit()

    elif uin == "C" or uin == "c":

        nameDF = input("What is the name/path of the dataframe to delete?\n.\n.\n.\n(ex. .\\dataframe.csv)>> ")
        deletedf(nameDF)

    elif uin == "MDS" or uin == "mds":

        nameDF = input("What is the name/path of your dataframe?\n.\n.\n.\n(ex. .\\dataframe.csv)>> ")
        JSONname = input("What is/will be the name/path your JSON dataset?\n.\n.\n.\n(ex. .\\New_Dataset.json)>> ")
        start_time = time.time()
        parseJSON(JSONname, nameDF)
        end_time = time.time()
        elapsed_time = end_time - start_time
        print(f"Completed in {elapsed_time} seconds")

    elif uin == "help" or uin == "HELP":

        print("This builder serves two main purposes:\n    - Create/Update a pandas dataframe for loading files for the dataset\n    - Read a specified dataframe into a .json dataset\n")
        print("NOTE: The dataframe builder can and will make its own dataframes unless given one which already exists,\n      if you are using a dataframe not made by the builder it must be in a .csv format with one column named 'text'")
        print("NOTE: When adding to a dataframe if you enter a dataframe which already has data, the new data will be appended to it")
        print("NOTE: When parsing into JSON, if you enter a JSON which already has data, the new data will be appended to it")
        input("Press enter to leave help menu>> \n")
    
    elif uin == "A" or uin == "a":

        # enter datframe builder
        print("\n.\n.\n.\n***************************\n**** DATAFRAME BUILDER ****\n***************************\n\nWelcome to the dataframe builder")
        folderPath = input("Instructions\n- You will first select a path to the directory your files are in\n- Then you will enter the name of your dataframe\n- Then you will select the file(s) in the directory you want to read\n.\n.\n.\nWhat is your directory path (relative to the current directory)?\n(ex. .\\all_my_files_here)>> ")
        dataframePath = input("What is your dataframe name/path (relative to the current directory)?\n.\n.\n.\n(ex. .\\dataframe.csv)>> ")
        while True:
            print("\n.\n.\n.\n***************************\n**** DATAFRAME BUILDER ****\n***************************\n")
            uin2 = input("What would you like to do?\nCommands (case sensitive):\nh : return home\nnf : read new file into dataframe\nraf : recursively read all files in directory into dataframe\nnd : change directory path\ncdf : change dataframe path\nq : quit\n.\n.\n.\n>> ")
            
            if uin2 == "q":

                print("exiting...")
                exit()

            if uin2 == "nf":

                fileName = input("What is the name of your file?\n.\n.\n.\n(ex. .\\core.v)>> ")
                filetodf(folderPath, fileName, dataframePath)
                print(f"{os.path.relpath(dataframePath)} updated successfully...")
                
            elif uin2 == "raf":

                isRecurr = input("Do you need to read recursively (i.e. reading through subdirectories within the parent)?\n.\n.\n.\n(Y/N)>> ")
                if isRecurr == "Y" or isRecurr == "y":
                    specificFile = input("Are you looking for any specific file types (i.e. *.txt, *.py, etc)?\n.\n.\n.\n(Y/N)>> ")
                    if specificFile == "Y" or specificFile == "y":
                        fileTypes = input("Enter however many file types you want separated by spaces\n.\n.\n.\n(ex. '*.txt *.v *.csv')>> ")
                        time_elapsed_start = time.time()
                        typeList = fileTypes.split(" ")
                        for ftype in typeList:
                            for ifile in glob.glob(os.path.join(folderPath, '**', f'{ftype}'), recursive=True):
                                print(f"Reading {ifile} into dataset...")
                                filetodf("", ifile, dataframePath)
                        time_elapsed_end = time.time()
                        time_elapsed = time_elapsed_end - time_elapsed_start
                        print(f"Competed in {time_elapsed} seconds")
                    else:
                        print("d")


                else:
                    for fileNames in os.listdir(folderPath):
                        # skip any directories
                        if os.path.isdir(fileNames):
                            continue
                        
                        filetodf(folderPath, fileNames, dataframePath)


                print(f"{os.path.relpath(dataframePath)} updated successfully...")
            elif uin2 == "nd":

                folderPath = input("What is your directory path (relative to the current directory)?\n.\n.\n.\n>> ")
                
                continue

            elif uin2 == "cdf":

                dataframePath = input("What is your dataframe name/path (relative to the current directory)?\n.\n.\n.\n(ex. .\\dataframe.csv)>> ")

                continue

            elif uin2 == "h":
                print("\n.\n.\n.")
                break
            else:
                print("Invalid Input...")

    else:
        print("Invalid input...\n.\n.\n.\n**************\n**** HOME ****\n**************\n\n")
        continue
    print("\n.\n.\n.\n**************\n**** HOME ****\n**************\n\n")