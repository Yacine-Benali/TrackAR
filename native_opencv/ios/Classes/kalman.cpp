#include <stdint.h>
#include <opencv2/core.hpp>
#include "opencv2/calib3d.hpp"
#include "opencv2/video/tracking.hpp"
#include "utils.cpp"
using namespace cv;
using namespace std;

extern "C"
{
    // global variable to hold previous time value
    int previousT = 0;
    // function header
    void updateTransitionMatrix(KalmanFilter &KF, int currentT);

    /**********************************************************************************************************/
    __attribute__((visibility("default"))) __attribute__((used))
    // this function is called on app start to return a KalmanFilter pointer to the app to use later
    KalmanFilter *
    getKalmanFilterInstance()
    {
        KalmanFilter *Kf = new KalmanFilter();
        return Kf;
    }

    /**********************************************************************************************************/
    __attribute__((visibility("default"))) __attribute__((used))
    // init Kalman filter function
    void
    initKalmanFilter(KalmanFilter &KF)
    {
        int nStates = 18;
        int nMeasurements = 6;
        int nInputs = 0;
        double dt = 0.125;
        KF.init(nStates, nMeasurements, nInputs, CV_64F); // init Kalman Filter

        setIdentity(KF.processNoiseCov, Scalar::all(0.1));     // set process noise
        setIdentity(KF.measurementNoiseCov, Scalar::all(0.3)); // set measurement noise
        setIdentity(KF.errorCovPost, Scalar::all(1000));        // error covariance

        /** transitionMatrix MODEL **/

        //  [1 0 0 dt  0  0 dt2   0   0 0 0 0  0  0  0   0   0   0]
        //  [0 1 0  0 dt  0   0 dt2   0 0 0 0  0  0  0   0   0   0]
        //  [0 0 1  0  0 dt   0   0 dt2 0 0 0  0  0  0   0   0   0]
        //  [0 0 0  1  0  0  dt   0   0 0 0 0  0  0  0   0   0   0]
        //  [0 0 0  0  1  0   0  dt   0 0 0 0  0  0  0   0   0   0]
        //  [0 0 0  0  0  1   0   0  dt 0 0 0  0  0  0   0   0   0]
        //  [0 0 0  0  0  0   1   0   0 0 0 0  0  0  0   0   0   0]
        //  [0 0 0  0  0  0   0   1   0 0 0 0  0  0  0   0   0   0]
        //  [0 0 0  0  0  0   0   0   1 0 0 0  0  0  0   0   0   0]
        //  [0 0 0  0  0  0   0   0   0 1 0 0 dt  0  0 dt2   0   0]
        //  [0 0 0  0  0  0   0   0   0 0 1 0  0 dt  0   0 dt2   0]
        //  [0 0 0  0  0  0   0   0   0 0 0 1  0  0 dt   0   0 dt2]
        //  [0 0 0  0  0  0   0   0   0 0 0 0  1  0  0  dt   0   0]
        //  [0 0 0  0  0  0   0   0   0 0 0 0  0  1  0   0  dt   0]
        //  [0 0 0  0  0  0   0   0   0 0 0 0  0  0  1   0   0  dt]
        //  [0 0 0  0  0  0   0   0   0 0 0 0  0  0  0   1   0   0]
        //  [0 0 0  0  0  0   0   0   0 0 0 0  0  0  0   0   1   0]
        //  [0 0 0  0  0  0   0   0   0 0 0 0  0  0  0   0   0   1]

        // position
        KF.transitionMatrix.at<double>(0, 3) = dt;
        KF.transitionMatrix.at<double>(1, 4) = dt;
        KF.transitionMatrix.at<double>(2, 5) = dt;
        KF.transitionMatrix.at<double>(3, 6) = dt;
        KF.transitionMatrix.at<double>(4, 7) = dt;
        KF.transitionMatrix.at<double>(5, 8) = dt;
        KF.transitionMatrix.at<double>(0, 6) = 0.5 * pow(dt, 2);
        KF.transitionMatrix.at<double>(1, 7) = 0.5 * pow(dt, 2);
        KF.transitionMatrix.at<double>(2, 8) = 0.5 * pow(dt, 2);

        // orientation
        KF.transitionMatrix.at<double>(9, 12) = dt;
        KF.transitionMatrix.at<double>(10, 13) = dt;
        KF.transitionMatrix.at<double>(11, 14) = dt;
        KF.transitionMatrix.at<double>(12, 15) = dt;
        KF.transitionMatrix.at<double>(13, 16) = dt;
        KF.transitionMatrix.at<double>(14, 17) = dt;
        KF.transitionMatrix.at<double>(9, 15) = 0.5 * pow(dt, 2);
        KF.transitionMatrix.at<double>(10, 16) = 0.5 * pow(dt, 2);
        KF.transitionMatrix.at<double>(11, 17) = 0.5 * pow(dt, 2);

        /** MEASUREMENT MODEL **/

        //  [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
        //  [0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
        //  [0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
        //  [0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0]
        //  [0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0]
        //  [0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0]

        KF.measurementMatrix.at<double>(0, 0) = 1;  // x
        KF.measurementMatrix.at<double>(1, 1) = 1;  // y
        KF.measurementMatrix.at<double>(2, 2) = 1;  // z
        KF.measurementMatrix.at<double>(3, 9) = 1;  // roll
        KF.measurementMatrix.at<double>(4, 10) = 1; // pitch
        KF.measurementMatrix.at<double>(5, 11) = 1; // yaw
    }

    /**********************************************************************************************************/
    __attribute__((visibility("default"))) __attribute__((used))
    // KalmanFilter predict and correct
    void
    updateKalmanFilter(KalmanFilter &KF,
                       Mat &measurement,
                       Mat &translationEstimated,
                       Mat &eulerAnglesEstimated,
                       int currentT)
    {
        // update dt
        updateTransitionMatrix(KF, currentT);
        // First predict, to update the internal statePre variable
        Mat prediction = KF.predict();
        // The "correct" phase that is going to use the predicted value and our measurement
        Mat estimated = KF.correct(measurement);
        // Estimated translation
        translationEstimated.at<double>(0) = estimated.at<double>(0);
        translationEstimated.at<double>(1) = estimated.at<double>(1);
        translationEstimated.at<double>(2) = estimated.at<double>(2);
        // Estimated euler angles
        //Mat eulers_estimated(3, 1, CV_64F);
        eulerAnglesEstimated.at<double>(0) = estimated.at<double>(9);
        eulerAnglesEstimated.at<double>(1) = estimated.at<double>(10);
        eulerAnglesEstimated.at<double>(2) = estimated.at<double>(11);
        //
        double roll = eulerAnglesEstimated.at<double>(0);
        double pitch = eulerAnglesEstimated.at<double>(1);
        double yaw = eulerAnglesEstimated.at<double>(2);
        //platform_log("yaw2: %f, pitch2: %f, roll2: %f", yaw, pitch, roll);
        //
        // Convert estimated quaternion to rotation matrix
        //! rotation_estimated = euler2rot(eulers_estimated);
    }

    // update KalmanFilter transition matrix with the current dt
    void updateTransitionMatrix(KalmanFilter &KF, int currentT)
    {
        double dt = ((double)currentT - (double)previousT) / (double)1000;

        previousT = currentT;
        // position
        KF.transitionMatrix.at<double>(0, 3) = dt;
        KF.transitionMatrix.at<double>(1, 4) = dt;
        KF.transitionMatrix.at<double>(2, 5) = dt;
        KF.transitionMatrix.at<double>(3, 6) = dt;
        KF.transitionMatrix.at<double>(4, 7) = dt;
        KF.transitionMatrix.at<double>(5, 8) = dt;
        KF.transitionMatrix.at<double>(0, 6) = 0.5 * pow(dt, 2);
        KF.transitionMatrix.at<double>(1, 7) = 0.5 * pow(dt, 2);
        KF.transitionMatrix.at<double>(2, 8) = 0.5 * pow(dt, 2);

        // orientation
        KF.transitionMatrix.at<double>(9, 12) = dt;
        KF.transitionMatrix.at<double>(10, 13) = dt;
        KF.transitionMatrix.at<double>(11, 14) = dt;
        KF.transitionMatrix.at<double>(12, 15) = dt;
        KF.transitionMatrix.at<double>(13, 16) = dt;
        KF.transitionMatrix.at<double>(14, 17) = dt;
        KF.transitionMatrix.at<double>(9, 15) = 0.5 * pow(dt, 2);
        KF.transitionMatrix.at<double>(10, 16) = 0.5 * pow(dt, 2);
        KF.transitionMatrix.at<double>(11, 17) = 0.5 * pow(dt, 2);
    }
}