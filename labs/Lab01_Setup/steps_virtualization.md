# Virtual Machine Deployment

The objective of this lab is to:

* Establish 6 hosts Rocky Linux 8 as the base operating system
* Install Kafka using the Confluent community edition
 
## Step 1:  Install virtualization software

There are multiple ways to run multiple Linux hosts.  You can use physical servers,
cloud-based virtual machines, or virtual machines.  In this lab we will focus on the
most inexpensive and simplest option by installing a virtualization software on your
laptop or desktop.  Using this approach, you will be able to run multiple virtual
machines on a single host.

Any virtualization software will work for these labs.  The virtualization software
you choose is largely dependent on the operating system you have running on your
laptop or workstation and which software you feel most comfortable using.  Some of
the options include:

* Oracle VirtualBox (Windows/Linux/Mac) - Free Open Source
* VMware Fusion (Mac) or Workstation (Windows/Linux) - Free for non-commercial use
* Parallels Desktop (Mac) - $$$

## Step 2:  Download a Rocky Linux 9 ISO

An ISO is a file containging a an entire copy of an optical disk such as a CD-ROM.
These are frequenty used to install software such as Linux.  An ISO can be used by
virtualiation software to similate the process of booting an installation image and
performing a full install of an operating system such as Linux, Windows, or Mac.

If you do not wish to install Rocky Linux from scratch, you can also download a
pre-built image by searching the web for "virtualbox rocky linux 9 image" and find
an image file that someone else has already created for you.

Here is an example of a pre-built Rocky Linux 9 image.  Kafka only requires a Java
JDK to run, so you can choose a minimal installation image unless you prefer to have
a full graphical environment.

* https://www.linuxvmimages.com/images/rockylinux-9/


## Step 3:  Create a Rocky Linux 9 virtual machine

See instructions: https://docs.rockylinux.org/guides/virtualization/vbox-rocky/

## Step 4:  Create 6 virtual machines

## Step 5:  Install the Java JDK

## Step 6:  Install Confluent Kafka
