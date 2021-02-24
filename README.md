# sac_rotation: 
- Rotate the 3 - dimentional seismogram from ZNE component to ZRT and LQT component
  - This code done for 3 file. The automatically job for series of file need to have extra works
  - Job can be done with 2 step.
    - run the bash file: set_taup_slowness.sh for all the $sacfile (with all hearder of event and station informations writed)
      ```bash
        chmod +x set_taup_slowness.sh
        ./set_taup_slowness.sh
      ```
    
        - Required "tauP" toolkit 
        - The ray parameter will automatically assign in T0 flag of $sacheader
    - Give the parameter to mfile 
      - give the name of 3 components (ZNE) to the <main.m> script (line 7~9)
      - choose the time for start and stop (in case the timeseries to long)
      - give the value of P-wave velocity beneath station (commonly 0 km) at line 14 
      ![image](https://user-images.githubusercontent.com/14089462/108981118-5fa2b400-76c7-11eb-8637-8662b86511a4.png)
     - run the <main.m>
   - Input: 3 files of seismogram (Z-N-E)
   - Output: 
      - 4 rotated seismogram (R - T - L - Q)
      - figure for all traces
      ![A](https://user-images.githubusercontent.com/14089462/108980866-1d797280-76c7-11eb-8813-e0716cd40758.jpg)
