if you'd like to reorganize functions/subroutines within or between the source files, please take note if what you wish to move is or is used by a jump table. The table structure may become skewed which will cause unpredictable behavior. 

Every jump table is either in identityJmpTable.x68 or parseInstructionMain.x68