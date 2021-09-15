# Test Workflow

Install [SCING](https://github.com/hisplan/scing) or run the following command to create a conda environment and install Cromwell and Java Runtime:

```
conda create -n cromwell python=3.8 pip
conda activate cromwell
conda install -c cyclus java-jre
pip install cromwell-tools==2.4.1
```

Submit a HelloWorld workflow:

```
cromwell-tools submit \
    --secrets-file ~/keys/cromwell-secrets.json \
    --wdl test-workflow/HelloWorld.wdl \
    --inputs-files test-workflow/HelloWorld.inputs.json \
    --label-file test-workflow/HelloWorld.labels.json
```

where `~/keys/cromwell-secrets.json` should point to your own secrets file.

If the job submission is successful, you will get a job ID on your screen:

```
{"id":"b7d42381-6f06-4373-8be9-a1097752f52c","status":"Submitted"}
```

Find your job ID in the Job Manager to check the status of your job.
