FROM ubuntu:22.04 AS coder

RUN apt-get update && apt-get install -y git

WORKDIR /opt/src

RUN git clone --single-branch --branch opt_save \
      https://github.com/rohitrango/FireANTs.git


FROM mambaorg/micromamba:ubuntu22.04

ARG MAMBA_DOCKERFILE_ACTIVATE=1

# Copy the source from builder
COPY --from=coder /opt/src/FireANTs /opt/src/FireANTs

# Install CLI scripts into /usr/local/bin
USER root
RUN cp /opt/src/FireANTs/scripts/fireantsRegistration /usr/local/bin && \
    chmod +x /usr/local/bin/fireantsRegistration && \
    chown -R mambauser /opt/src/FireANTs

USER mambauser

RUN micromamba create -y -n fireants python=3.7 pip && \
    micromamba clean -a -y

RUN micromamba run -n fireants \
    pip install --no-cache-dir /opt/src/FireANTs

ENV ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=1 \
    OMP_NUM_THREADS=1 \
    MKL_NUM_THREADS=1 \
    ENV_NAME=fireants

ENTRYPOINT ["/usr/local/bin/_entrypoint.sh"]
CMD ["bash"]
