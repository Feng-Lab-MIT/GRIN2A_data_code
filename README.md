## How to download the project in MATLAB

> [!WARNING]
> Do not use Download ZIP.
> It will not include large files tracked with Git LFS.

### 1. Make sure MATLAB supports Git

MATLAB R2014b or later includes built-in Git integration.
If you don't see the Source Control panel, install [Git](https://git-scm.com/install) and restart MATLAB.

### 2. Enable Git LFS

In MATLAB’s Command Window, run:

```
!git lfs install
```

(You only need to do this once per computer.)

### 3. Clone the Repository

Run:

```
!git clone https://github.com/Feng-Lab-MIT/GRIN2A_data_code.git [local_folder_path]
```

Replace `[local_folder_path]` with the folder where you want to save the project, for example:

```
!git clone https://github.com/Feng-Lab-MIT/GRIN2A_data_code.git C:\Users\YourName\Documents\MATLAB\GRIN2A_data_code
```

or on macOS:

```
!git clone https://github.com/Feng-Lab-MIT/GRIN2A_data_code.git ~/Documents/MATLAB/GRIN2A_data_code
```

### 4. (Optional) Pull Large Files from LFS

If `.mat` files are text placeholders, run:

```
!git lfs pull
```

## Where files are located

1. Raw behavior data are here: 
`data for figures/Data_final.mat`, `data for figures/Fig_S9_and_figS10S_SSFO.mat`.

2. Direct data for Plots in figures are in `data for figures`.

3. Data for generating figures in figure 1, 5, 6 is stored in `Data_final.mat`.
Behavior data for generating figures in figure S9 and figure S10 are stored in `Fig_S9_and_figS10S_SSFO.mat`.

4. In `data for figures` folder, use `Fig.1.m`, `Fig.5.m`, `Fig.6.m` and `Fig.S9_and-figS10.m` to compute the parameters we presented in figure 1, 5, 6, S9 and S10. Plots and statistics were done in  `data/Fig.1_3_6_S9_S10_behavior.prism`.

5. HMM data in figure 2, 5, 6 can be found in `Fig.2_5_6_HMM.prism`. Code for generating these data can be found in folder `model_hmm_bayesian/HMM`. Raw data and intermedia data is stored at the same folder.

6. Bayesian inference data were plotted in `Fig.2_baysian_final.prism` and `Fig.2_baysian_HMM.prism`.Code for generating these data can be found in folder `model_hmm_bayesian\Bayesian`. Raw data and intermedia data is stored in the same folder.

7. Figure 3a fUS results can be found in `Fig3.a_fUS_ReHomo.prism` under folder `data for figures`. The matlab code  `fUS/fig_3a_local_connect_step4_comp_atlas_v2_20240907KCC.m`. Raw data and intermedia data is stored at `fUS`.

8. Figure 3 in vivo ephys results can be found in `data for figures/Fig_3c_invivo.m` and `Fig.3d.prism`.

9. In vitro ephys results can be found in `data for figures/Fig.3efg_invitro.prism`.

10. Figure 4 (in vivo electrophysiology in task) data and code can be found in folder `invivo_ephys`. Data and code for plotting example neurons in figure 4 a-c and f-h can be found in subfolder `invivo_ephys/ephys example neurons`. Data and code computing figure 4d and 4i can be found in the subfolder `code/Fig_4_in vivo ephys/significant_correlated_neurons`. Decoding code  can be found in the subfolder `invivo_ephys/decoding`.