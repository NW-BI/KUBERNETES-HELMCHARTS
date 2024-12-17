# KUB-APP-DAGSTER
Kubernetes Applikation Dagster

# Secrets

## Setup

1. To add a secret, we need the Program sops, which can be found in Kepass under Kubernetes/secrets
   1. The Program sops can be placed in your favorite location for binary programs (e.g. C:\Executables\bins\ )
   2. Make sure, to include the folder where sops.exe is included into your path variables. Otherwise you will always have to specify the whole path for execution.
      ```powershell
      C:\Executables\bins\sops.exe filename
      # instead of
      sops filename
      ```
2. Move File keys.txt to $HOME\AppData\Roaming\sops\age\keys.txt
3. Install vim if not on your system (Test with just typing vim into powershell. Exit with typing :q and then hit Enter)
4. Now you can open the files in env/stg/secret.values.yaml env/prod/secret.values.yaml
5. To include a secret into the system, follow these steps:
   1. Base encode secret to base64 in powershell
      ```powershell
      echo -n "<secret>" | base64
      ```
    2. Use sops to include the secret in one of the secret yaml files. One of
        ```powershell
        sops ./env/stg/secret.values.yaml
        sops ./env/prod/secret.values.yaml  
        ```
    3. Navigate to the Bottom of the file. 
       1. Press i for insert mode
       2. insert key: value (value = base64 encoded version of your secret)
       3. close file by pressing esc then :wq and hit enter
       4. The secret was successfully written to the file
    4. Kubernetes now needs the knowledge of using this secret and implementing it into the cluster. All secrets are described in the folder ./templates/secrets in a yaml
       1.   Create a new yaml file with a descriptive name according to your secret in ./templates/secrets
       2.   Fill the yaml with the following example information
            ```yaml
            apiVersion: v1
            data:
              AVS_SFTP_SERVERNAME: {{ .Values.avs_sftp_servername }} # key (AVS_SFTP_SERVERNAME) is how the environment variable will be named in dagster. .Values.avs_sftp_servername is the name in the according secrets file
            kind: Secret
            metadata:
              creationTimestamp: null
              name: avs-sftp-servername # name used in other kubernetes yaml files when referencing. 
              namespace: dagster
            ---  # separation between secrets
            apiVersion: v1
            data:
              AVS_SFTP_PW: {{ .Values.avs_sftp_pw }}
            kind: Secret
            metadata:
              creationTimestamp: null
              name: avs-sftp-pw
              namespace: dagster
            ---
            apiVersion: v1
            data:
              AVS_SFTP_BENUTZER: {{ .Values.avs_sftp_benutzer }}
            kind: Secret
            metadata:
              creationTimestamp: null
              name: avs-sftp-benutzer
              namespace: dagster
            ```
    5. File for dagster_user_deployments can be found in ./env/prod/values.dagster_deployments.yaml (and stg)
       1. There the metadata names have to be included in the secrets sections
          ```yaml
                  envSecrets:
                    - name: avs-sftp-servername
                    - name: avs-sftp-pw
                    - name: avs-sftp-benutzer
                  etc...
          ```
        2. This has to be specified in every user_deployment the secret has to exist
# Using dry-run

1. kubectl dry-run befehl ausführen
e.g.

```powershell
kubectl create secret generic dagster-target --from-literal=TARGET="prod" -n dagster --dry-run=client -oyaml
```
