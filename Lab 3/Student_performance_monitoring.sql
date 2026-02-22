CREATE TABLE [dbo].[Certification_result] (
  [record_book_id] bigint  NOT NULL,
  [subject_id] bigint  NOT NULL,
  [semester_number] int  NOT NULL,
  [grade] int  NOT NULL,
  [pass_date] date  NOT NULL,
  PRIMARY KEY CLUSTERED ([record_book_id], [subject_id], [semester_number])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [dbo].[Curriculum_subject] (
  [subject_id] bigint  NOT NULL,
  [semester_number] int  NOT NULL,
  [hours] int  NOT NULL,
  [certification_type] varchar(10)  NOT NULL,
  PRIMARY KEY CLUSTERED ([semester_number], [subject_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [dbo].[Student] (
  [record_book_id] bigint  NOT NULL,
  [name] varchar(20)  NOT NULL,
  [surname] varchar(20)  NOT NULL,
  [patronymic] varchar(20)  NULL,
  [current_semester] int  NOT NULL,
  PRIMARY KEY CLUSTERED ([record_book_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [dbo].[Subject] (
  [subject_id] bigint  NOT NULL,
  [subject_name] varchar(40)  NOT NULL,
  PRIMARY KEY CLUSTERED ([subject_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

ALTER TABLE [dbo].[Certification_result] ADD CONSTRAINT [record_book_id] FOREIGN KEY ([record_book_id]) REFERENCES [dbo].[Student] ([record_book_id])
GO
ALTER TABLE dbo.Certification_result ADD CONSTRAINT FK_Certification_result_Curriculum_subject FOREIGN KEY (semester_number, subject_id) REFERENCES dbo.Curriculum_subject (semester_number, subject_id);
GO
ALTER TABLE [dbo].[Curriculum_subject] ADD CONSTRAINT [subject_id] FOREIGN KEY ([subject_id]) REFERENCES [dbo].[Subject] ([subject_id])
GO

