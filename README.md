# Volumometry Processing for Rock Deformation Experiments

This method aims to produce quantitative, reproducible values for dilatancy from rock deformation experimental data. The experimental data was collected using a triaxial deformation apparatus with a servo-controlled pore pressure pump to monitor pore volume changes in a fault gouge sample. This code could easily be used to process dilatancy data that is recovered from measurements of changes in shear zone width in biaxial apparatus. 

In a velocity step test, an initial shear enhanced compaction phase drastically reduces the sample pore volume until the sample yields. After the sample yields, the pore volume continues to decrease but at a lower rate of decrease. The imposed velocity steps cause compaction or dilation of the sample material that is superimposed on this overall compaction trend. If the pore pressure is held at a set point throughout the test, any volume changes in the control system can be assumed to correspond directly to changes in pore volume in the sample. 

# User Instructions:
This code was developed using MatLab R2021b (academic use) with the Curve Fitting toolbox. The data position of the start of the velocity step of interest has to be entered manually into the function. For consistency, every velocity step was processed with a ‘time_dep’ phase for the first 100μm of displacement after the imposed velocity step change. This is to remove the time period of the fluid flow from the sample to the pore pressure control pump before the volumometry measurement will register the change. 

Using the values for ‘vel_step’ and ‘time_dep’, the data are split into separate matrices preceding and following the velocity step change. A linear regression model fits a polynomial curve to the pore volumometry data and returns the coefficient of determination (R2) for the fit of the model. The pre-yield shear enhanced compaction phase is included in the model but it excludes the time-dependent data in ‘time_dep’. The code then incrementally adds the value entered for ‘step’ to the data in the velocity step of interest. This ‘step’ value will be a positive or negative value depending on whether the imposed velocity has increased or decreased, respectively. A new linear regression model is then fitted to the whole dataset and if the R2 value has increased, the code will continue in the loop to add the value of ‘step’ to the velocity step of interest. This loop concludes when the R2 value begins to decrease, as the fit of the linear regression model to the overall compaction trend is no longer improving. As the loop goes one iteration past the optimum R2 value, the code reverts to the previous set of values with the best R2 value. The final stage of the code is to plot the uncorrected and corrected data as a visual cue to the user of the offset identified.

In experiments with multiple velocity step changes, the code needs to retain the previous corrections of the data as the deviation from the overall compaction trend will then impact the model for subsequent velocity step changes. The function ‘pf_correct’ is used to correct the velocity steps that have been previously processed. The values for ‘vel_step’, ‘time_dep’ and the returned value of ‘offset’ need to be given in the inputs for ‘pf_correct’.

![apdx_dilation_figure](https://user-images.githubusercontent.com/56039889/194540564-1e968475-b0fe-428e-8d44-b23085a39738.png)

# Acknowledgements
This code was developed in conjunction with Prof. D.R. Faulkner and L.O. Brotherson. We acknowledge financial support from the UK Research Innovation (UKRI) Natural Environment Research Council (NERC) for a DTP studentship at the University of Liverpool that was awarded to I.R. Ashman and the grant NE/V011804/1 that was awarded to D.R. Faulkner. 