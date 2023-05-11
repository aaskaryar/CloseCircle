ZStack {
    Group {
  //friends
        Text("friends").font(.custom("Nunito SemiBold", size: 16))

//posts
        Text("posts").font(.custom("Nunito Bold", size: 16))

//image-gallery 1
        Rectangle()
        .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
        .frame(width: 19, height: 19)

//Rectangle 30
        RoundedRectangle(cornerRadius: 11)
        .fill(Color(#colorLiteral(red: 0.9058823585510254, green: 0.9137254953384399, blue: 0.9333333373069763, alpha: 1)))
        .frame(width: 165, height: 40)

//Rectangle 31
        ZStack {
            RoundedRectangle(cornerRadius: 11)
            .fill(Color(#colorLiteral(red: 0.9058823585510254, green: 0.9137254953384399, blue: 0.9333333373069763, alpha: 1)))

            RoundedRectangle(cornerRadius: 11)
            .strokeBorder(Color(#colorLiteral(red: 0.8196078538894653, green: 0.27843138575553894, blue: 0.5490196347236633, alpha: 1)), lineWidth: 2)
        }
        .frame(width: 165, height: 40)

//Frame 12
        Rectangle()
        .fill(Color.clear)
        .frame(width: 375, height: 277)

//Rectangle 30
        RoundedRectangle(cornerRadius: 11)
        .fill(Color(#colorLiteral(red: 0.9058823585510254, green: 0.9137254953384399, blue: 0.9333333373069763, alpha: 1)))
        .frame(width: 150, height: 150)

//hobbies
        Text("hobbies").font(.custom("Nunito SemiBold", size: 16))

//Hobbies
        Rectangle()
        .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
        .frame(width: 60, height: 60)
        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12999999523162842)), radius: 10, x: 0, y: 4)

//Ellipse 1
        Image(uiImage: #imageLiteral(resourceName: "Ellipse 1"))
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 150, height: 150)
        .clipShape(Circle())
        .frame(width: 150, height: 150)
        .shadow(color: Color(#colorLiteral(red: 0.8196078538894653, green: 0.27843141555786133, blue: 0.5490196347236633, alpha: 0.15000000596046448)), radius: 31, x: 0, y: 0)
    }

    Group {
  //Rectangle 66
        Rectangle()
        .fill(Color(#colorLiteral(red: 0.9686274528503418, green: 0.9764705896377563, blue: 1, alpha: 1)))
        .frame(width: 375, height: 812)
    }
}

