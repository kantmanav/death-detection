# Use tensorflow/tensorflow as the base image
# Change the build arg to edit the tensorflow version.
# Only supporting python3.
ARG TF_VERSION=2.4.2-gpu

FROM tensorflow/tensorflow:${TF_VERSION}

# System maintenance
RUN apt-get update && apt-get install -y graphviz && rm -rf /var/lib/apt/lists/* && /usr/bin/python3 -m pip install --no-cache-dir --upgrade pip

WORKDIR /notebooks

# Copy the required setup files and install the deepcell-tf dependencies
COPY setup.py README.md requirements.txt /opt/death-detection/

# Prevent reinstallation of tensorflow and install all other requirements.
RUN sed -i "/tensorflow>/d" /opt/death-detection/requirements.txt && \
    pip install --no-cache-dir -r /opt/death-detection/requirements.txt

# Copy over deepcell notebooks
COPY notebooks/ /notebooks/

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--allow-root"]