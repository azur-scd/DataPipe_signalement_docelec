FROM jupyter/minimal-notebook:latest
USER root
RUN apt-get update
RUN apt-get install -yq --no-install-recommends default-jdk
ENV HOME=/home/jovyan
USER $NB_UID
RUN fix-permissions /home/$NB_USER
COPY --chmod=777 . .
RUN pip install -r linux_requirements.txt
RUN rm -r $HOME/work/
WORKDIR $HOME
EXPOSE 8866 8888 8889
VOLUME ["/home/jovyan/result_files","/home/jovyan/source_files"]
#CMD ["jupyter","notebook"]
#CMD jupyter notebook --NotebookApp.token='123456'
#CMD ["voila","execute_workflow_ui.ipynb"]
CMD voila execute_workflow_ui.ipynb --VoilaConfiguration.file_whitelist="['.*.(xml|csv)']"