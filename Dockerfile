FROM azurscd/base-notebook-java-userscd:latest
ENV HOME=/home/scd
USER scd
COPY --chmod=777 . .
RUN pip install -r requirements.txt
WORKDIR $HOME
EXPOSE 8866 8888
VOLUME ["/home/scd/result_files","/home/scd/source_files", "/home/scd/temporary_files", "/home/scd/xslt"]
#CMD ["sh","-c", "jupyter notebook --notebook-dir=/home/scd --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='123456' --NotebookApp.base_url='/datapipe-signalement-docelec'"]
CMD voila workflow_ui.ipynb --Voila.base_url='/datapipe-signalement-docelec/' --VoilaConfiguration.file_whitelist="['.*.(xml|csv)']"