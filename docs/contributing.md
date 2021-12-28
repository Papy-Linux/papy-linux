# Contributing

This distribution is open-source and every contribution is welcome. Though, it shouldn't be against the distro's philosophy.

!!! note

    I'll always privilege my personnal usage of the distro, as I created it for my usage at the beginning. That means that if you make a contribution which is pertinent but which I don't want to have on my computers, I may refuse it. In such cases, don't hesitate to fork it!

## Components

There are 3 components you can contribute to :

| Component | Path |
|---|---|
| The live | `live` |
| The installer | `live/airootfs/opt/install/` |
| The distro | `live/airootfs/opt/install/rootfs/` |

**Tip:** the "dotfiles" are in `live/airootfs/opt/install/rootfs/etc/skel/`

## The live

`live/`

The live is based on the [baseline](https://gitlab.archlinux.org/archlinux/archiso/-/tree/master/configs/baseline) profile of [archiso](https://wiki.archlinux.org/title/archiso).

**Building**

**Arch:** If you are on Arch, or any other linux distribution which has archiso (are there?), and have archiso installed, you can build the live by cd-ing in live and running `mkarchiso -v .`. The resulting ISO will be in `live/out/`.

**Other:** If you are on any other operating system (I must confess I'm using Windows 10), you must install [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) and run `vagrant up`. If you already did `vagrant up`, modified files and want to build it again, you have to do `vagrant provision`. You'll find the ISO in `vagrant_out/`.

## The installer

`live/airootfs/opt/install/`

Okay, let's talk about the installer... That's not the cleanest thing I made ever. It's just a simple bash script that does all you do when installing Arch manually with the installation guide. At some time I wanted to use Calamares but searching on Internet there is very very few documentation about it, so it was even simpler to do everything from zero. And it made me learn a lot actually.

The installer doesn't support UEFI yet, as the computer I want to install the distro on still uses BIOS. This will be fixed soon.

It manages partitonning, locale setup, base system and packages installation.

**Note:** you can see polybar binary is included directly in the repository. It's because compiling it from the AUR made the installation nearly twice longer.

## The distribution

`live/airootfs/opt/install/rootfs/`

The distribution's folder contains all the files that will be copied on the final system, for example i3 or polybar configuration files.

PS: Files resulting in `/home/user/` are in `rootfs/etc/skel/` ;)
