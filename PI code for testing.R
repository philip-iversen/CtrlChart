# PI code for testing.R
# Code written by Phil Iversen to help with testing Jeff's code

# Read in the mean shift data

library (readxl)
library (tidyverse)
library (qicharts2)

usrdata = read_excel ("meanshiftdata.xlsx")

ms.runs = unique (usrdata$Run)
ms.runs
ms.nruns = length (ms.runs)

# analyze runs 1-5, then 1-6, etc., saving the run.signal result from the
# qic summary each time.
# Step 0: Only do this if there are at least 6 runs
# Step 1: Runs 1-5, save the full run.signal column from the qic$data object
# Step 2: Loop over runs 6 to ms.runs, analyzing the cumulative data and 
#         save just the one run.signal value from summary(qic)
# Step 3: Run the full data set and overwrite the runs.signal column

# Can change 5 to a variable for the MSR window size, if desired

usrdata.1_5 = usrdata [usrdata$Run %in% ms.runs [1:5], ]
table.1_5 = as_tibble(qic(x = usrdata.1_5$Run, 
                          y = log10(usrdata.1_5$Data), 
                          chart = "xbar", return.data = TRUE))
new.run.signal = table.1_5$runs.signal

for (runid in 6:ms.nruns) {
  usrdata.temp = usrdata [usrdata$Run %in% ms.runs [1:runid], ]
  run.signal.temp = summary (qic(x = usrdata.temp$Run, 
                                 y = log10(usrdata.temp$Data), 
                                 chart = "xbar"))
  new.run.signal = c(new.run.signal, as.logical (run.signal.temp$runs.signal))
}

new.run.signal

# For testing with the main program, UsrCtrlCht.R

usrData = read_excel ("meanshiftdata.xlsx")
usrData$Run = as.Date (usrData$Run)
