{ mkShell
, python3
}:

let python-env = python3.withPackages (pyPkgs: with pyPkgs; [
      numpy
      numba
      scipy
      mujoco
      pygame
      pillow
      opencv4
      pyyaml
      pynput
      tqdm
      termcolor
      imageio
      h5py
      lxml
      hidapi
      robosuite
    ]);

    pythonIcon = "f3e2";

in mkShell rec {
  name = "robocasa";

  packages = [
    python-env
  ];

  # This is to have a leading python icon to remind the user we are in
  # the Alf python dev environment.
  shellHook = ''
    export PS1="$(echo -e '\u${pythonIcon}') {\[$(tput sgr0)\]\[\033[38;5;228m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]} (${name}) \\$ \[$(tput sgr0)\]"
  '';
}
