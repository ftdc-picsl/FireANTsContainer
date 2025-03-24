FROM mambaorg/micromamba:ubuntu22.04

ARG MAMBA_DOCKERFILE_ACTIVATE=1

RUN micromamba create -y -n fireants python=3.7 git && \
    micromamba clean -a -y

# Install fireants
RUN micromamba run -n fireants \
      pip install git+https://github.com/rohitrango/FireANTs.git

ENV ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=1 \
    ENV_NAME=fireants \
    PYTHONHISTFILE=/tmp/python_history

ENTRYPOINT ["/usr/local/bin/_entrypoint.sh"]
CMD ["bash"]