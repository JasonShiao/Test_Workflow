#include "mainwindow.h"

#include <QApplication>
#include <QImage>
#include <opencv2/core/mat.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <QDebug>

#include <boost/thread.hpp>
#include <boost/chrono.hpp>

/**
 * @brief convert cv::Mat to QImage
 *        WARNING: Use copy() because the data in cv::Mat will be released later. 
 *                 Without using copy, the data memory is shared between QImage and Mat and 
 *                 it could cause a crash (invalid memory access)
 */
QImage cvMatToQImage (const cv::Mat &inMat) {
  switch (inMat.type()) {
    case CV_8UC4:
      return QImage(inMat.data, inMat.cols, inMat.rows, static_cast<int>(inMat.step), QImage::Format_ARGB32).copy();
    case CV_8UC3:
      return QImage(inMat.data, inMat.cols, inMat.rows, static_cast<int>(inMat.step), QImage::Format_RGB888).copy().rgbSwapped();
    case CV_8UC1:
      return QImage(inMat.data, inMat.cols, inMat.rows, static_cast<int>(inMat.step), QImage::Format_Grayscale8).copy();
    default:
      qWarning() << "cvMatToQImage() failed, the type of mat is: " << inMat.type();
      break;
  }

  return QImage();
}

cv::Mat QImageToCvMat(const QImage &inImage) {
  switch (inImage.format()) {
    case QImage::Format_ARGB32: {
      cv::Mat mat(inImage.height(), inImage.width(),
                  CV_8UC4,
                  const_cast<uchar*>(inImage.bits()),
                  static_cast<size_t>(inImage.bytesPerLine())
      );
      return mat;
    }
    case QImage::Format_RGB888: {
      QImage swapped = inImage;

      swapped = swapped.rgbSwapped();

      return (cv::Mat (swapped.height(), swapped.width(),
                  CV_8UC4,
                  const_cast<uchar*>(swapped.bits()),
                  static_cast<size_t>(swapped.bytesPerLine())).clone()
      );
    }
    case QImage::Format_Grayscale8: {
      cv::Mat mat(inImage.height(), inImage.width(),
                  CV_8UC1,
                  const_cast<uchar*>(inImage.bits()),
                  static_cast<size_t>(inImage.bytesPerLine())
      );
      return mat;
    }
    default:
      qWarning() << "QImageToCvMat() failed, the QImage format is: " << inImage.format();
  }

  return cv::Mat();
}

void wait(int seconds)
{
  boost::this_thread::sleep_for(boost::chrono::seconds{seconds});
}

void thread()
{
  for (int i = 0; i < 5; ++i)
  {
    wait(1);
    //std::cout << i << '\n';
  }
}

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.show();

    boost::thread t{thread};
    QImage test_qimage{100, 100, QImage::Format_Grayscale8	};
    cv::Mat image = QImageToCvMat(test_qimage);

    return a.exec();
}
