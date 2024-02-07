import pandas as pd
import os.path as op
import os

uin = input("What would you like to do?\nC : clear dataframe\nA : add to dataframe\nQ : quit builder\n.\n.\n.\n>>")

if uin == "C" or uin == "c":
    open("dataframe.csv", "w")
    os.remove("dataframe.csv")
    print("file cleared\nexiting...")
    exit()
if uin == "Q" or uin == "q":
    print("exiting...")
    exit()

folderPath = input("Instructions - You will first select a path to the folder your files are in\nThen you will select each file in the folder you want to read\n.\n.\n.\nWhat is your folder path: ")
while True:
    # nf : read new file\nnd : change folder path
    uin2 = input("What would you like to do?\nCommands (case sensitive):\nnf : read new file\nnd : change folder path\nq : quit\n.\n.\n.\n>> ")
    if uin2 == "q":
        print("exiting...")
        exit()
    if uin2 == "nf":
        fileName = input("What is the name of your file: ")
    elif uin2 == "nd":
        folderPath = input("What is your folder path: ")
        continue
        # "RISC_V/System_verilog/Cores/RV12/Logic/riscv_bu.sv"
    filePath = folderPath + fileName
    outFileName = "dataframe.csv"

    # open read file
    fd = open(filePath)
    # read text
    text = fd.readlines()
    newStructure = {'text' : [text]}

    if not (op.isfile(outFileName)):
        # make dataframe
        df = pd.DataFrame(newStructure)
        print("Creating...")
    else:
        # read dataframe
        df = pd.read_csv(outFileName)
        df = pd.concat([df, pd.DataFrame(newStructure)], ignore_index=True)
        print("Updating...")

    # update csv file
    df.to_csv(outFileName, index=False)

