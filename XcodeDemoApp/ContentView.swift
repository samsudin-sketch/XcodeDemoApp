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
struct RecipesListView: View { // ej klar
    let dummyRecipes = [//dummyRecipes är en array (lista) av Recipe-objekt.
        Recipe(id: 1, title: "Pizza", author: "Anna", description: "Tomat och ost"),
        Recipe(id: 2, title: "Pasta", author: "Erik", description: "Med gräddsås")
    ]
    
    
    var body: some View {
        VStack {//spacing?
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
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}



//gör en modell (recipe)

struct Recipe: Identifiable {//Identifiable möjliggör att användning i ForEach
    let id: Int
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
            Divider()
            Text(recipe.description)
                .padding(.top)
        }
        .navigationTitle("Detaljer")
    }
}
