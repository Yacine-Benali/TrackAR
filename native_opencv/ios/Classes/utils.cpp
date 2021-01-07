#include <stdint.h>
#include <opencv2/core.hpp>
#include "opencv2/calib3d.hpp"
#include "opencv2/video/tracking.hpp"
// #include "print.cpp"
using namespace cv;
using namespace std;

// Converts a given Rotation Matrix to Euler angles but it does not work
// source https://docs.opencv.org/master/dc/d2c/tutorial_real_time_pose.html
cv::Mat rot2euler(const cv::Mat &rotationMatrix)
{
    cv::Mat euler(3, 1, CV_64F);

    double m00 = rotationMatrix.at<double>(0, 0);
    double m02 = rotationMatrix.at<double>(0, 2);
    double m10 = rotationMatrix.at<double>(1, 0);
    double m11 = rotationMatrix.at<double>(1, 1);
    double m12 = rotationMatrix.at<double>(1, 2);
    double m20 = rotationMatrix.at<double>(2, 0);
    double m22 = rotationMatrix.at<double>(2, 2);

    double bank, attitude, heading;

    // Assuming the angles are in radians.
    if (m10 > 0.998)
    { // singularity at north pole
        bank = 0;
        attitude = CV_PI / 2;
        heading = atan2(m02, m22);
    }
    else if (m10 < -0.998)
    { // singularity at south pole
        bank = 0;
        attitude = -CV_PI / 2;
        heading = atan2(m02, m22);
    }
    else
    {
        bank = atan2(-m12, m11);
        attitude = asin(m10);
        heading = atan2(-m20, m00);
    }

    euler.at<double>(0) = bank;
    euler.at<double>(1) = attitude;
    euler.at<double>(2) = heading;
    return euler;
}
// Function for conversion
double degreeToRadian(double degree)
{
    double pi = 3.14159265359;
    return (degree * (pi / 180));
}

double radianToDegree(double radian)
{
    double pi = 3.14159;
    return (radian * (180 / pi));
}

// Converts a given Rotation Matrix to Euler angles and it works
void getEulerAngles(Mat &rotCamerMatrix, Vec3d &eulerAngles)
{

    Mat cameraMatrix, rotMatrix, transVect, rotMatrixX, rotMatrixY, rotMatrixZ;
    double *_r = rotCamerMatrix.ptr<double>();
    double projMatrix[12] = {_r[0], _r[1], _r[2], 0,
                             _r[3], _r[4], _r[5], 0,
                             _r[6], _r[7], _r[8], 0};

    decomposeProjectionMatrix(Mat(3, 4, CV_64FC1, projMatrix),
                              cameraMatrix,
                              rotMatrix,
                              transVect,
                              rotMatrixX,
                              rotMatrixY,
                              rotMatrixZ,
                              eulerAngles);

    // double yaw = eulerAngles[1];
    // double pitch = eulerAngles[0];
    // double roll = eulerAngles[2];
}



// Checks if a matrix is a valid rotation matrix.
bool isRotationMatrix(Mat &R)
{
    Mat Rt;
    transpose(R, Rt);
    Mat shouldBeIdentity = Rt * R;
    Mat I = Mat::eye(3, 3, shouldBeIdentity.type());

    return norm(I, shouldBeIdentity) < 1e-6;
}

// Calculates rotation matrix to euler angles
// The result is the same as MATLAB except the order
// of the euler angles ( x and z are swapped ).
void getEulerAngles3(Mat &R, Vec3d &eulerAngles)
{

    // if (!isRotationMatrix(R))
    //     print("nigga wtf this ain't a rotation matrkix");

    float sy = sqrt(R.at<double>(0, 0) * R.at<double>(0, 0) + R.at<double>(1, 0) * R.at<double>(1, 0));

    bool singular = sy < 1e-6; // If

    float x,
        y, z;
    if (!singular)
    {
        x = atan2(R.at<double>(2, 1), R.at<double>(2, 2));
        y = atan2(-R.at<double>(2, 0), sy);
        z = atan2(R.at<double>(1, 0), R.at<double>(0, 0));
    }
    else
    {
        x = atan2(-R.at<double>(1, 2), R.at<double>(1, 1));
        y = atan2(-R.at<double>(2, 0), sy);
        z = 0;
    }
    //Vec3f(x, y, z);
    eulerAngles[0] = x;
    eulerAngles[1] = y;
    eulerAngles[2] = z;
}
