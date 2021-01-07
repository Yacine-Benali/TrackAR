#include <stdint.h>
#include <opencv2/core.hpp>
#include "opencv2/calib3d.hpp"
#include "opencv2/video/tracking.hpp"
#include <math.h>

#include "kalman.cpp"
#include "print.cpp"

using namespace cv;
using namespace std;
#define PI 3.141592653
extern "C"
{
    /**********************************************************************************************************/
    __attribute__((visibility("default"))) __attribute__((used)) float *quaternion2Euler(float *q)
    {
        float w = q[0];
        float x = q[1];
        float y = q[2];
        float z = q[3];


        float ret[3] = {0};
        float test = x * y + z * w;
        if (test > 0.4999f)
        {
            ret[2] = 2.0f * atan2f(x, w);
            ret[1] = PI / 2;
            ret[0] = 0.0f;

            q[0] = ret[0];
            q[2] = ret[1];
            q[1] = ret[2];
            return q;
        }
        if (test < -0.4999f)
        {
            ret[2] = 2.0f * atan2f(x, w);
            ret[1] = -PI / 2;
            ret[0] = 0.0f;

            q[0] = ret[0];
            q[2] = ret[1];
            q[1] = ret[2];
            return q;
        }
        float sqx = x * x;
        float sqy = y * y;
        float sqz = z * z;
        ret[2] = atan2f(2.0f * y * w - 2.0f * x * z, 1.0f - 2.0f * sqy - 2.0f * sqz);
        ret[1] = asin(2.0f * test);
        ret[0] = atan2f(2.0f * x * w - 2.0f * z * y, 1.0f - 2.0f * sqx - 2.0f * sqz);

        ret[0] *= 180 / PI;
        ret[1] *= 180 / PI;
        ret[2] *= 180 / PI;

        q[0] = ret[0];
        q[2] = ret[1];
        q[1] = ret[2];
        return q;
    }

    __attribute__((visibility("default"))) __attribute__((used)) double *native_add(KalmanFilter &KF,
                                                                                    double *listPtr,
                                                                                    int size,
                                                                                    int imCols,
                                                                                    int imRows,
                                                                                    int currentT)
    {
        // 2D points of facial landmarks detected by the App
        vector<Point2d> imagePoints;
        // Nose tip
        imagePoints.push_back(Point2d(*(listPtr + 0), *(listPtr + 1)));
        // bottom mouth
        imagePoints.push_back(Point2d(*(listPtr + 2), *(listPtr + 3)));
        // Left eye left corner
        imagePoints.push_back(Point2d(*(listPtr + 4), *(listPtr + 5)));
        // Right eye right corner
        imagePoints.push_back(Point2d(*(listPtr + 6), *(listPtr + 7)));
        // Left Mouth corner
        imagePoints.push_back(Point2d(*(listPtr + 8), *(listPtr + 9)));
        // Right mouth corner
        imagePoints.push_back(Point2d(*(listPtr + 10), *(listPtr + 11)));
        // Left cheek
        // imagePoints.push_back(Point2d(*(listPtr + 12), *(listPtr + 13)));
        // // Right cheek
        // imagePoints.push_back(Point2d(*(listPtr + 14), *(listPtr + 15)));
        // // Left ear
        // imagePoints.push_back(Point2d(*(listPtr + 16), *(listPtr + 17)));
        // // Right ear
        // imagePoints.push_back(Point2d(*(listPtr + 18), *(listPtr + 19)));

        // yaw and roll detected by the App AI Model
        double aiYaw = *(listPtr + 20);
        double aiRoll = *(listPtr + 21);

        // 3D model points.
        std::vector<Point3d> modelPoints;
        // Nose tip
        modelPoints.push_back(Point3d(0.0, 0.0, 0.0));
        // Chin
        modelPoints.push_back(Point3d(0.0, -170.0, -65.0));
        // Left eye / corner
        modelPoints.push_back(Point3d(-16.0, 123.0, -135.0));
        // Right eye / corner
        modelPoints.push_back(Point3d(16.0, 123.0, -135.0));
        // Left Mouth corner
        modelPoints.push_back(Point3d(-15.0, -160.0, -125.0));
        // Right mouth corner
        modelPoints.push_back(Point3d(15.0, -160.0, -125.0));
        // Left cheek
        // modelPoints.push_back(Point3d(-22.0, -6.0, -135.0));
        // // Right cheek
        // modelPoints.push_back(Point3d(22.0, -6.0, -135.0));
        //Left ear
        // modelPoints.push_back(Point3d(-300.0, 150.0, -50.0));
        // // Right ear
        // modelPoints.push_back(Point3d(300.0, 150.0, -50.0));

        // Camera internals
        double focalLength = imCols;
        // Approximate focal length.
        Point2d center = Point2d(imCols / 2, imRows / 2);
        Mat cameraMatrix = (Mat_<double>(3, 3) << focalLength, 0, center.x, 0, focalLength, center.y, 0, 0, 1);

        // Assuming no lens distortion
        Mat distCoef = Mat::zeros(4, 1, DataType<double>::type);

        // Output rotation and translation
        Mat rotationVector;
        // Rotation in axis-angle form
        Mat translationVector;
        // Solve for pose
        solvePnP(modelPoints, imagePoints, cameraMatrix, distCoef, rotationVector, translationVector, false, SOLVEPNP_ITERATIVE);
        // converts Rotation Vector to Matrix
        Mat rotationMatrix;
        Rodrigues(rotationVector, rotationMatrix);
        // get eulerAngles
        Vec3d eulerAngles;
        getEulerAngles(rotationMatrix, eulerAngles);
        //
        // Vec3d eulerAngles3;
        // getEulerAngles3(rotationMatrix, eulerAngles3);
        // eulerAngles3[0] = radianToDegree(eulerAngles3[0]);
        //
        double pitch = eulerAngles[0];
        double yaw = -aiYaw;
        double roll = -aiRoll;                              //eulerAngles[2];
        double x = (translationVector.at<double>(0) / 50);  // x
        double y = -(translationVector.at<double>(1) / 50); // y;
        double z = (translationVector.at<double>(2) / 50);  // z;
        pitch = -pitch;
        if (pitch > 0)
        {
            pitch = pitch - 180;
        }
        else
        {
            pitch = 180 + pitch;
        }
        // if (pitch > 0)
        // {
        //     pitch = pitch - 170;
        // }
        // else
        // {
        //     pitch = 170 + pitch;
        // }
        // pitch = -pitch;
        // Set measurement to predict
        Mat measurements(6, 1, CV_64FC1);
        measurements.at<double>(0) = x;     // x
        measurements.at<double>(1) = y;     // y
        measurements.at<double>(2) = z;     // z
        measurements.at<double>(3) = roll;  // roll
        measurements.at<double>(4) = pitch; // pitch
        measurements.at<double>(5) = yaw;   // yaw

        Mat translationEstimated(3, 1, CV_64FC1);
        Mat eulerAnglesEstimated(3, 3, CV_64FC1);
        updateKalmanFilter(KF, measurements, translationEstimated, eulerAnglesEstimated, currentT);

        double rollE = eulerAnglesEstimated.at<double>(0);
        double pitchE = eulerAnglesEstimated.at<double>(1);
        double yawE = eulerAnglesEstimated.at<double>(2);

        /* returning both the raw and estimated values */
        // from Kalman
        listPtr[0] = translationEstimated.at<double>(0); // x
        listPtr[1] = translationEstimated.at<double>(1); // y
        listPtr[2] = translationEstimated.at<double>(2); // z
        listPtr[3] = yawE;                               // yaw
        listPtr[4] = pitchE;                             // pitch
        listPtr[5] = rollE;                              // roll

        // raw Data
        listPtr[6] = x;      // x
        listPtr[7] = y;      // y
        listPtr[8] = z;      // z
        listPtr[9] = yaw;    // yaw
        listPtr[10] = pitch; // pitch
        listPtr[11] = roll;  // roll

        return listPtr;
    }
}