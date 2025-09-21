//
//  ContentView.swift
//  XcodeDemoApp
//
//  Created by Sebastian Samsudin on 2025-09-11.
//

import SwiftUI

//startvyn
struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack (spacing : 20) {
                Text("Första Vyn")
                    .font(.title)
                
                NavigationLink(destination: RecipesListView()) {
                    Text("Gå till nästa vy")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    
                }
            }
            .navigationTitle("Hem")
        }
    }
}

//"Andra" Vyn
struct RecipesListView: View {
    let dummyRecipes = [//dummyRecipes är en array (lista) av Recipe-objekt.
        Recipe(id: UUID(), title: "Pizza", author: "Anna", description: "Tomat och ost"),
        Recipe(id: UUID(), title: "Pasta", author: "Erik", description: "Med gräddsås"),
        Recipe(id: UUID(), title: "Sallad", author: "Lina", description: "Fräsch och grön")
    ]
    
    
    var body: some View {
        VStack (spacing: 20){//space mellan sakerna i den vertikala satsen
            Text("Recept")
                .font(.largeTitle)
                .bold()
            
            ForEach(dummyRecipes) { recipe in            //kör koden inuti blocket för varje recept
                NavigationLink(destination: RecipeDetailView( recipe: recipe)){
                    VStack(alignment: .leading) {
                        Text(recipe.title)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("av \(recipe.author)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()//space mellan texten i knappen och knappens ytterkant
                    .frame(maxWidth: .infinity, alignment: .leading) //knappbredd
                    .background(Color.blue)
                    .cornerRadius(10)//rundar av hörnen
                    .shadow(radius: 3) // skugga runt knappen
                }
            }
            
            Spacer()//flyttar allt uppåt
        }
        .padding()//space "runt om" recept och knappar
        .navigationTitle(Text("Recept"))
    }
}



//gör en modell (recipe)

struct Recipe: Identifiable {//Identifiable möjliggör att användning i ForEach
    let id: UUID //ändrat från int till uuid
    let title: String
    let author: String
    let description: String
}



#Preview {
    ContentView()
}

//tredje vyn - RecipeDetailView som är en detaljvy
struct RecipeDetailView: View {
    let recipe: Recipe //En konstant variabel som är ett objekt av typen Recipe
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10){
            Text(recipe.title)
                .font(.largeTitle)
            Text("av \(recipe.author)")
                .font(.title2)
                .foregroundColor(.gray)
            Divider()//skapar en tunn linje mellan
            Text(recipe.description)
                .padding(.top)//padding endast på en angiven sida
        }
        .navigationTitle("Detaljer")
    }
}
