# Add some ARGs and ENVs to emulate the flow of our file
ARG FROM_IMAGE=debian
FROM $FROM_IMAGE AS crust


RUN fallocate -l 300MB test.txt
RUN echo "ANOTHER THING TO ECHO"
RUN fallocate -l 500MB test3.txt

# Build a runtime using `crust` as the base image
FROM crust AS philling
COPY hello.sh . 
ENTRYPOINT [ "/bin/bash", "./hello.sh"]   

