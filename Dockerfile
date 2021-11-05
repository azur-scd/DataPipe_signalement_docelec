FROM gegedenice/base-notebook-java-userscd:latest
ENV HOME=/home/scd
USER scd
COPY --chmod=777 . .
RUN pip install -r linux_requirements.txt
WORKDIR $HOME
EXPOSE 8866 8888 8889
VOLUME ["/home/scd/result_files","/home/scd/source_files"]
#CMD ["jupyter","notebook"]
#CMD jupyter notebook --NotebookApp.token='123456'
#CMD ["voila","execute_workflow_ui.ipynb"]
CMD voila execute_workflow_ui.ipynb --VoilaConfiguration.file_whitelist="['.*.(xml|csv)']"