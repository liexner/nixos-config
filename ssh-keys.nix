let
  keys = {
    tower = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCl8W3NY+dlThgNx441yj9NY+lEmVWs3SOgtQn5Tw2pORsuSSoLh25S0fXB9cy6GCVMbG3Esopu9+qFGyDBuELMNIToOQOAQmEaGRavxb1Arb8ggZi84G87bly8qrsD4NfpayVZVR65VAMi8rXlSfSPAY6UlH32Mo49ywCjiAqdzGPU5Xo9JmdnfEt0ONm4puwGaTw3V+0m6hAhZXCNLKwxp3+7ImAsqo04EDKnWEcqqQ82zajYa/i4h0zzYQINzhl+qhXQLR9oWV/p6IjHnXPe5Z5sSadQJKJdD6wpJ5xNKd9TYWnlUFhWpPKqxMaUpvW/CGNmZJBkHAR1aOYR+FXlk9SVIfqrRqaY94BCkyQqclHUhKmXScFD4HDiRhDX75B8sYqNJfkHOL8KZIqPG4xjcbEgSv9CaA55q5cr8yMZk48YhJiFP7v5rtA4gKWJwY/EwKsTTW8cDWXa+8cW8ylglPZTDwkN3y6aw2ZQIXJNZ6R0/jdyet0Tulugu83ftE8= liexner@nixos";
    elitedesk = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDXYkAXVUZWoMiumw6jOL85QI3tOK6zGPnroCyBrx0wReuJ+oKZpAL1Jdj9lWKQyRebNPEtmAQnEOeo0RBgnvRwQ0oLvUkun9krm7f/fYwuB14xD7qiaZ2nbWTYEISTEFnBqqHEBe555IBQdbfuQkHx81broi+NrV35VWc2U1LOkPAcbE0ByETUyGh1dU52oV2+Sr/E6eEXWxSRkcXZhSx0LFxvAD3fCvsZAwYmVt0/ctKfa+rNX4k1pzokat/BWXRR3L52yJB31iCVi1/6Op4b9BmMeyEU6YcaRfuzxNS+juTPmSOS77NQ3LJM6icnRGjzirxRFuv7n027H4pttkbRIedkCp6cMRlQrdq0z/SFf1lWmAC6l2coPdPgLhEub3nxeYIn5eFHmDUPulRmu5surmtzmgLXjLIAm0mB5WTFbk+OwNuDBlStvEx8o4RKW72AYl9AsyKHAARPxkC9qk0pQ7pCcK9H2+hNmEWaEVKnZ0FeSC1K2ItwT95n3rEqLE= liexner@server";
    wsl = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqbPTff2s5oVZDSZiVpd9S8UdUF5gtwwlYNpm5kTYTxNlVvzdR/jicVuXA4AfugNP6YzK4FVHtCL+z/wFLSYPQsZh7W5mlHGvWexTC0p9I3FJTm+ihZYk60S030/ErznuOLc0QomhUZLridXuurFAbFn9DZo2mq+tho1duuhavXQvhSCBCmIy7ZbXau81MMJg9/5q+SIsTEPAPvYXo2rLEMbcYTDYOXKzlnZEG+Gvjvvr6AkSOLOzsjG1nwbn/E2Za+B1x2zkx2CntYXQH389yi6fn+PZKjVDLk1Fmha/WnuYv5BrmWfaQdpN+cMqCNC0DL+88RtsaAEf1I+Zim5A04Zod8PazqN2cv9m9K9Td8HUKKSxIcSFITH5EhtsZxfNMpiZkbltl3KtbKoluoqQJJwq5JFM7zyVhFbdqDAGXcAtN4JaSbPDlIK18qELvKRkUIZ4LEl9SsQw8JjnuHdJFdraxvYiYOsslVq8IKJu/J5YDcT+0/gf9/PWpFCmbBv8= nixos@nixos";
  };
in
{
  inherit keys;

  allKeys = builtins.attrValues keys;

  #keysFor = names: builtins.map (name: keys.${name}) names;

  #groups = {
  #  personal = [ keys.macbook ];
  #  servers = [ keys.wsl keys.tower ];
  #  all = builtins.attrValues keys;
  #};

}
