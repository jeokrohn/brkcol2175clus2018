FROM jupyter/base-notebook

ADD requirements.txt .

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends unzip \
    && wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip \
    && unzip ngrok-stable-linux-amd64.zip \
    && install -v -D ngrok /bin/ngrok \
    && rm -f ngrok-stable-linux-amd64.zip ngrok \
    && pip install --upgrade pip \
    && pip install -r requirements.txt \
    && rm -f requirements.txt

# this is a dirty hack. The amusements module does not work with Python 3. The UniversalPark.py provided fixes some
# issues and we simply force that single file into the site-packages directory
ADD UniversalPark.py /opt/conda/lib/python3.6/site-packages/amusement/parks/universal

ADD Notebook/*.ipynb work/Notebook/
ADD Notebook/*.pdf work/Notebook/

ADD jupyter_notebook_config.py /home/jovyan/.jupyter/
RUN chown -R jovyan:users .

USER jovyan

EXPOSE 8888 4040

