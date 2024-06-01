FROM nvidia/cuda:11.8.0-devel-ubuntu22.04 as cuda

# Miniconda install copy-pasted from Miniconda's own Dockerfile reachable 
# at: https://github.com/ContinuumIO/docker-images/blob/master/miniconda3/debian/Dockerfile
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 git mercurial subversion && \
    apt-get clean

RUN apt-get install python
# RUN sudo apt-get python

FROM nvidia/cuda:11.8.0-devel-ubuntu22.04 as builder

# Actual Code setup
WORKDIR /code

COPY --from=cuda . .

RUN python -m pip install pipenv

COPY Pipfile Pipfile.lock ./
RUN pipenv install

COPY . .

CMD ["python", "-m", "pipenv", "shell"]