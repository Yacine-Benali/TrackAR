// #include <stdint.h>
// #include <opencv2/core.hpp>
// #include "opencv2/calib3d.hpp"

//  stackoverflow version
// extern "C" __attribute__((visibility("default"))) __attribute__((used)) double native_add(double *listPtr, int size, int imCols, int imRows)
// {

//     // 2D image points. If you change the image, you need to change vector
//     std::vector<cv::Point2d> image_points;
//     //left ear
//     image_points.push_back(cv::Point2d(*(listPtr + 12), *(listPtr + 13)));

//     // right ear
//     image_points.push_back(cv::Point2d(*(listPtr + 0), *(listPtr + 1)));
//     // Chin
//     image_points.push_back(cv::Point2d(*(listPtr + 2), *(listPtr + 3)));

//     // Left eye left corner
//     image_points.push_back(cv::Point2d(*(listPtr + 4), *(listPtr + 5)));
//     // Right eye right corner
//     image_points.push_back(cv::Point2d(*(listPtr + 6), *(listPtr + 7)));
//     // Left Mouth corner
//     image_points.push_back(cv::Point2d(*(listPtr + 8), *(listPtr + 9)));
//     // Right mouth corner
//     image_points.push_back(cv::Point2d(*(listPtr + 10), *(listPtr + 11)));

//     // 3D model points.
//     std::vector<cv::Point3d> model_points;
//     // Nose tip
//     model_points.push_back(cv::Point3d(2.37427, 110.322, 21.7776));   // l eye (v 314)
//     model_points.push_back(cv::Point3d(70.0602, 109.898, 20.8234));   // r eye (v 0)
//     model_points.push_back(cv::Point3d(36.8301, 78.3185, 52.0345));   //nose (v 1879)
//     model_points.push_back(cv::Point3d(14.8498, 51.0115, 30.2378));   // l mouth (v 1502)
//     model_points.push_back(cv::Point3d(58.1825, 51.0115, 29.6224));   // r mouth (v 695)
//     model_points.push_back(cv::Point3d(-61.8886, 127.797, -89.4523)); // l ear (v 2011)
//     model_points.push_back(cv::Point3d(127.603, 126.9, -83.9129));    // r ear (v 1138)

//     std::vector<double> rv(3), tv(3);
//     cv::Mat rvec(rv), tvec(tv);
//     cv::Vec3d eulerAngles;
//     cv::Mat ip(image_points);

//     cv::Mat op = cv::Mat(model_points);

//     rvec = cv::Mat(rv);
//     double _d[9] = {1, 0, 0,
//                     0, -1, 0,
//                     0, 0, -1};
//     Rodrigues(cv::Mat(3, 3, CV_64FC1, _d), rvec);
//     tv[0] = 0;
//     tv[1] = 0;
//     tv[2] = 1;
//     tvec = cv::Mat(tv);

//     double max_d = MAX(imRows, imCols);
//     double _cm[9] = {max_d, 0, (double)imCols / 2.0,
//                      0, max_d, (double)imRows / 2.0,
//                      0, 0, 1.0};
//     cv::Mat camMatrix = cv::Mat(3, 3, CV_64FC1, _cm);

//     double _dc[] = {0, 0, 0, 0};

//     solvePnP(op, ip, camMatrix, cv::Mat(1, 4, CV_64FC1, _dc), rvec, tvec, false, 1);

//     double rot[9] = {0};
//     cv::Mat rotM(3, 3, CV_64FC1, rot);
//     Rodrigues(rvec, rotM);
//     double *_r = rotM.ptr<double>();

//     double _pm[12] = {_r[0], _r[1], _r[2], tv[0],
//                       _r[3], _r[4], _r[5], tv[1],
//                       _r[6], _r[7], _r[8], tv[2]};

//     cv::Mat tmp, tmp1, tmp2, tmp3, tmp4, tmp5;
//     cv::decomposeProjectionMatrix(cv::Mat(3, 4, CV_64FC1, _pm), tmp, tmp1, tmp2, tmp3, tmp4, tmp5, eulerAngles);

//     //! 20deg diff on y
//     double yTurn = eulerAngles[1];
//     double xTurn = eulerAngles[0];
//     double zTurn = eulerAngles[2];

//     return xTurn;
//     //return 5.3;
// }
