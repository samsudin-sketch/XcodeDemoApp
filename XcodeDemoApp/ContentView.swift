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
    
    @State private var recipes: [Recipe] = [] //kör nu tom array i början istället
    
    var body: some View {
        VStack (spacing: 20){//space mellan sakerna i den vertikala satsen
            Text("Recept")
                .font(.largeTitle)
                .bold()
            
            ForEach(recipes) { recipe in            //kör koden inuti blocket för varje recept ("recipe" kan bytas ut mot godtyckligt ord)
                VStack(alignment: .leading, spacing: 8) {
                    
                    NavigationLink(destination: RecipeDetailView( recipe: recipe)){
                        VStack(alignment: .leading) {//.leading skjuter innehållet till vänster
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
                    
                    //knapp för receptborttagning
                    Button(action: {
                        //tar bort rätt recept från listan
                        //först hämtar vi id:t för receptet som ska bort
                        let receptIdSomSkaTasBort = recipe.id
                        
                        //leta upp index för receptet i listan
                        let indexFörReceptet = recipes.firstIndex(where: { recept in
                            return recept.id == receptIdSomSkaTasBort
                        })
                        
                        // OM receptet hittades, ska det bort från listan
                        if let index = indexFörReceptet {
                            recipes.remove(at: index)
                            sparaReceptTillUserDefaults()
                        }
                    })
                    {
                        Text("Ta bort")
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
                Spacer()//flyttar allt uppåt
            }
            .padding()//space "runt om" recept och knappar
            .navigationTitle(Text("Recept"))
            .onAppear{
                laddaReceptFrånUserDefaults()
            }
            
        
    
}

        //skapa funktioner?
        //en ska kunna ta bort recpt ur listan OCH listan ska även sparas om. (userfedaults) borttagna recept ska ine komma tillbaka när appen startas om
        
        func sparaReceptTillUserDefaults() {
            let encoder = JSONEncoder() // Skapar en JSONEncoder – används för att konvertera Swift-objekt till JSON-data
            if let encodedData = try? encoder.encode(recipes) {
                UserDefaults.standard.set(encodedData, forKey: "sparadeRecept")
            }
        }
        
        //den andra ska kunna Läsa in sparade recept när appen starta För att visa användaren den senaste listan
        func laddaReceptFrånUserDefaults() {
            let decoder = JSONDecoder()
            if let savedData = UserDefaults.standard.data(forKey: "sparadeRecept"),
            let loadedRecipes = try? decoder.decode([Recipe].self, from: savedData) {
                recipes = loadedRecipes
            }
            
            else {
            // Om inga sparade recept, skapa grundlistan
            recipes = [
            Recipe(id: UUID(), title: "Pizza", author: "Anna", description: "Tomat och ost"),
            Recipe(id: UUID(), title: "Pasta", author: "Erik", description: "Med gräddsås"),
            Recipe(id: UUID(), title: "Sallad", author: "Lina", description: "Fräsch och grön")
            ]
            sparaReceptTillUserDefaults()
            }
    }
}


//gör en modell (recipe)
//ForEach,konvertera en instans av Recipe till JSON-data respektive läsa in en instans av Recipe från JSON-data*
struct Recipe: Identifiable, Encodable, Decodable {
    let id: UUID //ändrat från int till uuid
    let title: String
    let author: String
    let description: String
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


#Preview {
    ContentView()
}
