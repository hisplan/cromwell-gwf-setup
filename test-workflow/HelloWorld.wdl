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

        echo "Hello World!"
        echo "Hello ~{name}!" > msg.txt

        sleep 5
    >>>

    output {
        File out = "msg.txt"
    }
}

task SayDate {

    runtime {
        docker: "ubuntu:20.04"
        disks: "local-disk 2 HDD"
        cpu: 1
        memory: "1 GB"
    }

    command <<<
        set -euo pipefail

        date > msg.txt
    >>>

    output {
        File out = "msg.txt"
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

    call SayDate

    output {
        File greeting = SayName.out
        File today = SayDate.out
    }
}
