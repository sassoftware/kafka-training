# Apache Kafka Training

This repository contains labs, lectures, and reference material used to train
developers and operations how to use Apache Kafka.  Each lecture is intended
to present information on specific Kafka concepts.  Corresponding labs help
reinforce the lecture concepts through guided exercises.  Students can use
the lab scripts and config files to start a local instance of Kafka.  This
allows the user to experiment with Kafka by performing narrowly focussed tasks
that demonstrate how to apply the concepts discussed in each lecture.

## Prerequisites

* Java JDK 15 or higher
* A command-line git client available in the user or system $PATH
* An environment capable of running Bash shell scripts

## Getting Started

Each lab folder contains a set of files to guide the user through the concepts
the lab is intended to demonstrate.  The `README.md` file will provide a general
overview of the lab objectives.  The `steps.md` file contains step-by-step
instructions on how to start and interact with the Kafka server to learn
the concepts covered in the lab.

### Running

Use the following command to get information about the commands available for
managing a local Kafka instance:

```
cd labs
./kafka-server.sh
```

## Contributing

We welcome your contributions! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to submit contributions to this project. 

## License

This project is licensed under the [Apache 2.0 License](LICENSE).

## Additional Resources

* [Apache Kafka](https://kafka.apache.org/)
