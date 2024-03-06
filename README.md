# ARCHGEN LLM_training Dataset GitHub


-------------------Repo Breakdown------------------------
- ds_builder.py is the Python script for building the datasets

- To run the builder script use: python3 [path]\ds_builder.py
  + NOTE: The script has instructions for using it when it is run

- The RISC_V directory contains directories representing each GitHub used, and the corresponding files used to build the datasets.

- The datasets directory contains all parsed dataset.JSON files.
  + Current datasets in this directory are built from each corresponding GitHub in the RISC_V directory, for some sets the core verilog and peripheral/FPGA/etc verilog are divided into separate JSON files and   
    denoted as such.
    
- The dataset for Minerva contains nMigen code, not Verilog


