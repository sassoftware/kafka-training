# Preparing an Environment 

In this lab you will set up a single instances of Kafka.  Early labs will use
a single node in order to reduce complexity and focus on core concepts.  Once
the core concepts have been covered, later labs will introduce multi-node
clusters.  Using multiple instances will allow you to experiment with a
multi-node Kafka cluster and develop your understanding of how each node
interacts with its peers to form a cluster.

You are free to use whatever physical, virtual, or containized solution you wish
to run Kafka.  Instructions have been provided for several different virtualization
and containerization option so that you can choose the option that feels most
comfortable to you.  The focus of these labs is to teach you how to use Kafka,
not how to use a particular virtualization or containerization technology, so be
sure to pick the option that you already understand well.

Here are some options:

* Running local Kafka processes on a single host
* Virtualization using Oracle VirtualBox
* Containerization using Rancher Desktop

If you do not already have a strong understanding of virtualization or
containerization, please just run Kafka processes on a single host.
This will simplify your lab environment and allow you to focus on the Kafka
configuration rather than the technology used to run it.

## Select an environment

Select a local installation if:
* you have no experience with virtual machines or docker containers
* you will be working on a laptop or desktop with limited resources
* you do not have a need to learn Kafka in a specific tpye of environment
* you need to customize or debug the Kafka source code

Select a virtual machine installation if:
* you have a need to learn how Kafka can be managed on physical hosts or VMs
* you plan to use configuration management tools such as Ansible to install and configure Kafka
* you would like to save and restore snapshots of your lab work

Select a container installation if:
* you already have a strong undertaning of container technology (such as Docker)
* you plan to deploy Kafka in a Kubernetes environment
