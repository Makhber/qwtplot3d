#ifndef qwt3d_enrichment_std_h
#define qwt3d_enrichment_std_h

#include "qwt3d_enrichment.h"

namespace Qwt3D {

class Plot3D;

//! The Cross Hair Style
class QWT3D_EXPORT CrossHair : public VertexEnrichment
{
public:
    CrossHair();
    CrossHair(double rad, double linewidth, bool smooth, bool boxed);

    Qwt3D::Enrichment *clone() const override { return new CrossHair(*this); }

    void configure(double rad, double linewidth, bool smooth, bool boxed);
    void drawBegin() override;
    void drawEnd() override;
    void draw(Qwt3D::Triple const &) override;

private:
    bool boxed_, smooth_;
    double linewidth_, radius_;
    GLboolean oldstate_;
};

//! The Point Style
class QWT3D_EXPORT Dot : public VertexEnrichment
{
public:
    Dot();
    Dot(double pointsize, bool smooth);

    Qwt3D::Enrichment *clone() const override { return new Dot(*this); }

    void configure(double pointsize, bool smooth);
    void drawBegin() override;
    void drawEnd() override;
    void draw(Qwt3D::Triple const &) override;

private:
    bool smooth_;
    double pointsize_;
    GLboolean oldstate_;
};

//! The Cone Style
class QWT3D_EXPORT Cone : public VertexEnrichment
{
public:
    Cone();
    Cone(double rad, unsigned quality);
    ~Cone();

    Qwt3D::Enrichment *clone() const override { return new Cone(*this); }

    void configure(double rad, unsigned quality);
    void draw(Qwt3D::Triple const &) override;

private:
    GLUquadricObj *hat;
    GLUquadricObj *disk;
    unsigned quality_;
    double radius_;
    GLboolean oldstate_;
};

//! 3D vector field.
/**
        The class encapsulates a vector field including his OpenGL representation as arrow field.
        The arrows can be configured in different aspects (color, shape, painting quality).

*/
class QWT3D_EXPORT Arrow : public VertexEnrichment
{
public:
    Arrow();
    ~Arrow();

    Qwt3D::Enrichment *clone() const override { return new Arrow(*this); }

    void configure(int segs, double relconelength, double relconerad, double relstemrad);
    void setQuality(int val) { segments_ = val; } //!< Set the number of faces for the arrow
    void draw(Qwt3D::Triple const &) override;

    void setTop(const Qwt3D::Triple &t) { top_ = t; }
    void setColor(const Qwt3D::RGBA &rgba) { rgba_ = rgba; }

private:
    GLUquadricObj *hat;
    GLUquadricObj *disk;
    GLUquadricObj *base;
    GLUquadricObj *bottom;
    GLboolean oldstate_;

    double calcRotation(Qwt3D::Triple &axis, Qwt3D::FreeVector const &vec);

    int segments_;
    double rel_cone_length;

    double rel_cone_radius;
    double rel_stem_radius;

    Qwt3D::Triple top_;
    Qwt3D::RGBA rgba_;
};

} // ns

#endif
