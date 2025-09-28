# capsim-tmk
<h1>Capsim&reg;  DSP and Communications System Block Diagram Modeling and Simulation Text Mode Kernel (TMK) </h1>

CAPSIM&reg; Text Mode Kernel (TMK) is a hierarchical interactive block diagram simulation and design system for digital signal processing and communications. All Capsim TMK models are written in C with provisions for parameters, input /output buffers, internal state maintenance, and three phases of execution: initialization, run-time and wrap-up.
Capsim&reg;  Blocks are written in C embedded in XML for modular/re-usable design. Capsim&reg; includes a built in TCL interpreter for support of iterative simulation and design optimization.

Capsim&reg;  TMK has been the basis for advanced research projects and undergraduate and graduate courses in communications and signal processing.
Capsim&reg; TMK based designs have resulted in the rapid introduction of new products into the market. Start your projects with Capsim TMK's built in models and extensive DSP and communications applications. Then easily incorporate your own custom C models into Capsim&reg; TMK . Capsim&reg; TMK is provided with extensive documentation.

Capsim&reg; TMK has built in IIR and FIR filter design blocks. It also incorporates LMS and fast RLS adaptive filters and block LMS adaptive filters. More and more DSP and communication applications will be added to the Capsim&reg; TMK release. Capsim&reg; models end to end OFDM systems with acquistion, timing recovery, and  carrier offset estimation with channel modeling. Capsim&reg; also models MIMO OFDM systems for both closed loop and open loop systems.

Capsim&reg; with its flexible buffer connection management can handle mixed synchronous and asynchronous simulations. One key advantage of Capsim&reg; is that the blocks run at their natural sampling rate using the unique buffer connection architecture.

<h2>Capsim&reg; Blocks </h2>
The new model for block C code generation is illustrated below, Blocks are written in embedded C code in XML and transformed to C code and incorporated into Capsim&reg;. The XML code is transformed using XSLT (Extensible Stylesheet Language for Transformation) to C code and HTML for documentation. Tools are provided that automatically do the conversion from XML to C code when adding models to Capsim&reg;.

<h2>Capsim&reg; TMK History</h2>
Capsim&reg; was originaly developed by XCAD Corporation.  All XCAD Open Source projects have been transferred to and taken over by Silicon DSP Corporation. Silicon DSP Corporation has since 2006 added major enhancements to Capsim&reg; and Capsim&reg; TMK. The  predecessor and original model of CAPSIM&reg; was  BLOSIM.  BLOSIM is a block diagram signal processing simulation program, originally developed at the University of California, Berkeley, 1985. The primary authors were D. G. Messerschmitt and D. J. Hait. For papers on BLOSIM visit this link.  Since arrival at NCSU in November 1987, the program has been extensively debugged. Capsim&reg;  was completely remodeled, enhanced with new commands,  and improved by  XCAD Corporation and later by Silicon DSP Corporation. The person-hours spent on this task have made Capsim a vast improvement over the original in user convenience, capability and reliability and the complete elimimation of memory leaks allowing for unlimited simulation runs ( for example for BER in optocal links). 

The latest version changes the block models to full XML support with the capability to transform the C embedded in XML code to C/C++, SystemC, and HTML or stand alone C subroutines. A major enhancement has been the integration of TCL scripting capability where TCL scripts control the blocks in a block diagram and can change parameters and retrieve results from the blocks after a simulation completes.

The principal authors for the enhancements to BLOSIM are Professor Sasan Ardalan formerly with the Dept. of Electrical and Computer Engineering, North Carolina State Univertsity, Raleigh, NC and Jim Faber, Ph.D. 

