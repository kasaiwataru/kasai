 -以下を実行し、NetBSDのビルドを行った(ソースツリーをダウンロードするときに、-Pをつける必要があった？)
  ```
  cd /usr/NetBSD-0-csv-current/src  
  cvs update -dP  
  ./build.sh -O ../obj -T ../tools -U release
  ```
