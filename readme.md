 # Domain Cgroups
 
 **What is it**

 This repository will provide a more understandable output for the Cgroups 
 systemd-cgtop shows current cgroups resource usage, but it's too limited for our use case with cgroups on Plesk, and its output is not readily intelligible for end users.

 The script collects resource usage from the cgroups stats files located in sys/fs/cgroup and collates it into an easily to read table format ordered by max RAM usage per use(Plesk domain).

 **Usage**

 To use the script, simply download it using [the Github repository](https://raw.githubusercontent.com/layershift/domain_cgroups/master/domain_cgroups.sh) and execute it on the server.

 $ wget https://raw.githubusercontent.com/layershift/domain_cgroups/master/domain_cgroups.sh .

 $ chmod +x  ./domain_cgroups.sh

 $ ./domain_cgroups.sh

 Once the script is executed, it will ask for Filtering options as follows:
 Do you want the table sorted based on max Ram usage, or based on current ram usage?
 1. Current Ram usage
 2. Max ram usage 
 
 The first option (1. Current Ram usage) will filter all the domains based on the current Ram usage.
 The second option (2. Highest Ram usage) will filter all the domains based on Highest Ram usage recorded.
 **Example Output**

 Here is an example output of for the script:
 ```
 $ wget https://raw.githubusercontent.com/layershift/domain_cgroups/master/domain_cgroups.sh .

 $ chmod +x  ./domain_cgroups.sh

 $ ./domain_cgroups.sh
 Do you want the table sorted based on max Ram usage, or based on current ram usage?
 1. Current Ram usage
 2. Highest ram usage
 1

  +                 +                          +           +      +        +     +
  | User            | Domain                   | Current   | MB   | Max    | MB  |
  +                 +                          +           +      +        +     +
  | user3           | subd.domain2.tld         | 18        | MB   | 115    | MB  |
  | user2           | domain2.tld              | 17        | MB   | 233    | MB  |
  | user1           | domain1.tld              | 11        | MB   | 1378   | MB  |


 $ wget https://raw.githubusercontent.com/layershift/domain_cgroups/master/domain_cgroups.sh .

 $ chmod +x  ./domain_cgroups.sh

 $ ./domain_cgroups.sh
 Do you want the table sorted based on max Ram usage, or based on current ram usage?
 1. Current Ram usage
 2. Highest ram usage
 2
  +            +                          +           +      +        +     +
  | User      | Domain                   | Current   | MB   | Max    | MB  |
  +           +                          +           +      +        +     +
  | user1     | domain1.tld              | 11        | MB   | 1378   | MB  |
  | user2     | domain2.tld              | 17        | MB   | 233    | MB  |
  | user3     | subd.domain2.tld         | 18        | MB   | 115    | MB  |

 ```
 