version 1.0

task SayName {

    input {
        String name
    }

    runtime {
        docker: "ubuntu:20.04"
        disks: "local-disk 2 HDD"
        cpu: 1
        memory: "1 GB"
    }

    command <<<
        set -euo pipefail

        echo "Hello ~{name}!" > hello-world.txt
    >>>

    output {
        File out = "hello-world.txt"
    }
}

workflow HelloWorld {

    input {
        String name
    }

    call SayName {
        input:
            name = name
    }

    output {
        File outFile = SayName.out
    }
}
