-- Add new course procedure 
Create PROCEDURE [dbo].[AddNewCourse] 
(
  @CourseName nvarchar(255),
  @Description nvarchar(max),
  @MaxDegree float,
  @MinDegree float
)

AS
BEGIN
  -- Insert new course details into Courses table
  INSERT INTO Course (CourseName, CourseDescription, CourseMaxDegree, CourseMinDegree)
  VALUES (@CourseName, @Description, @MaxDegree, @MinDegree);
END;


-- Assign Instructor to Course
CREATE PROCEDURE AssignInstructorToCourse
    @UserId INT,
    @CourseId INT,
    @Year INT


AS
BEGIN
    INSERT INTO CourseInstructor (UserId, CourseId, Year)
    VALUES (@UserId, @CourseId, @Year);
END;
GO

-- Update Course Details
CREATE PROCEDURE UpdateCourseDetails
    @CourseId INT,
    @CourseName VARCHAR(255),
    @CourseDescription TEXT,
    @CourseMaxDegree INT,
    @CourseMinDegree INT


AS
BEGIN
    UPDATE Course
    SET CourseName = @CourseName,
        CourseDescription = @CourseDescription,
        CourseMaxDegree = @CourseMaxDegree,
        CourseMinDegree = @CourseMinDegree
    WHERE CourseId = @CourseId;
END;
GO


-- Delete Course
CREATE PROCEDURE DeleteCourse
    @CourseId INT

AS
BEGIN
    -- Deleting all related questions to the course
    DELETE FROM Question
    WHERE CourseId = @CourseId;

    -- Deleting all related course instructor records
    DELETE FROM CourseInstructor
    WHERE CourseId = @CourseId;

    -- Deleting the course
    DELETE FROM Course
    WHERE CourseId = @CourseId;
END;
GO

-- Delete Exam
CREATE PROCEDURE DeleteExam
    @ExamId INT

AS
BEGIN
    -- Deleting all related student answers for the exam
    DELETE sa
    FROM StudentAnswer sa
    INNER JOIN ExamQuestion eq ON sa.ExamQuestionId = eq.ExamQuestionId
    WHERE eq.ExamId = @ExamId;

    -- Deleting all related exam questions
    DELETE FROM ExamQuestion
    WHERE ExamId = @ExamId;

    -- Deleting the exam
    DELETE FROM Exam
    WHERE ExamId = @ExamId;
END;
GO

-- SearchCoursesByNameOrDescription 
CREATE VIEW SearchCoursesByNameOrDescription AS
SELECT 
    CourseId,
    CourseName,
    CourseDescription,
    CourseMaxDegree,
    CourseMinDegree
FROM 
    Course;
GO


-- SearchUsersByRoleOrDepartment
Create VIEW SearchUsersByRoleOrDepartment AS
SELECT 
    u.UserId,
    u.FirstName,
    u.LastName,
    u.Email,
    u.Role,
    s.StudentId,
    i.IntakeName,
    t.TrackName,
    b.BranchName,
    d.DepartementName
FROM 
    [User] u
LEFT JOIN 
    Student s ON u.UserId = s.StudentId
LEFT JOIN 
    Intake i ON s.IntakeId = i.IntakeId
LEFT JOIN 
    Track t ON i.TrackId = t.TrackId
LEFT JOIN 
    Branch b ON t.BranchId = b.BranchId
LEFT JOIN 
    Departement d ON b.DepartementId = d.DepartementId;
GO

-- SearchExamsByTypeOrDate
CREATE VIEW SearchExamsByTypeOrDate AS
SELECT 
    e.ExamId,
    e.ExamType,
    e.StartTime,
    e.EndTime,
    i.IntakeName,
    ci.UserId AS InstructorId,
    ci.CourseId
FROM 
    Exam e
JOIN 
    Intake i ON e.IntakeId = i.IntakeId
JOIN 
    CourseInstructor ci ON e.CourseInstructorId = ci.CourseInstructorId;
GO
