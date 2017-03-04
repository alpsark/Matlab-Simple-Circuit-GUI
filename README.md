# Matlab-Simple-Circuit-GUI
Written in Matlab  
Simple circuit with current and voltage source and resistance . 

This function takes the data in the "project.txt" and finds the voltages of nodes:

* You can edit the txt file from the GUI.

* You can also graph the change in the single element and how it affects the single node.

Data must have following rules:

1. Data will have a ground labeled as node 0 and other nodes will be labeled consecutively from 1 to n.

2. The first column is the unique identifier for the element whose first letter indicates the element type:

    * R,I or V and the rest is an integer.
    
3. The second and the third columns denote the node numbers of the element.

4. The last column denotes the value of the element in Ohms,Amperes or Volts.

5. NodeNumber@SecondColumn < NodeNumber@ThirdColumn.

6. Positive value for the current source means that the current is entering the Node@SecondColumn.

7. Positive value for the voltage source means: Voltage of Node@SecondColumn < Voltage of Node@ThirdColumn.

After changing project.txt run project.m in MATLAB

