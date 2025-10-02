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
    @State private var visaLäggTillFormulär = false
    
    var body: some View {
        VStack (spacing: 20){//space mellan sakerna i den vertikala satsen
            Text("Recept")
                .font(.largeTitle)
                .bold()
            
            ForEach(recipes) { recipe in            //kör koden inuti blocket för varje recept ("recipe" kan bytas ut mot godtyckligt ord)
                let recipeBinding = Binding<Recipe>(
                    get: {
                        recipe
                    },
                    set: { updated in
                        if let index = recipes.firstIndex(where: { $0.id == updated.id }) {
                            recipes[index] = updated
                        }
                    }
                )

                VStack(alignment: .leading, spacing: 8) {
                    //raden nedan: När användaren trycker på denna länk, navigera till RecipeDetailView och skicka med hela recipes som en Binding, samt en vanlig (icke-binding) kopia av det valda receptet
                    NavigationLink(destination: RecipeDetailView(recipes: $recipes, recipe: recipeBinding.wrappedValue)) {
                        VStack(alignment: .leading) {
                            Text(recipe.title)
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("av \(recipe.author)")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 3)
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
            
            .toolbar {  //här i toolbar skapar vi ett plus som får formuläret att visas
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        visaLäggTillFormulär = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear{
                laddaReceptFrånUserDefaults()
            }
            
            //  när visaLäggTillFormulär sätts till true, visas ett formulär (LäggTillReceptFormulär); ny vy där man kan mata in titel, författare och beskrivning.
            .sheet(isPresented: $visaLäggTillFormulär) {
                LäggTillReceptFormulär(recipes: $recipes, sparaFunktion: sparaReceptTillUserDefaults)
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


struct LäggTillReceptFormulär: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var recipes: [Recipe]               // recipes inte är en egen lokal lista, utan är direkt kopplad till listan i RecipesListView – alltså själva huvudlistan med recept
    var sparaFunktion: () -> Void                // ← Funktion som sparar till UserDefaults
    
    // 1. Samlar in receptets data via State-variabler kopplade till formuläret
    @State private var title = ""
    @State private var author = ""
    @State private var description = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Titel")) {
                    TextField("Ange titel", text: $title) // ← Data samlas här
                }
                Section(header: Text("Författare")) {
                    TextField("Ange författare", text: $author)
                }
                Section(header: Text("Beskrivning")) {
                    TextField("Ange beskrivning", text: $description)
                }
            }

            .navigationTitle("Nytt recept")
            .navigationBarItems(
                
                // "Avbryt"-knapp: stänger formuläret utan att spara
                leading: Button("Avbryt") {
                    dismiss()
                },
                
                // 2. Här skapas ett nytt Recipe
                // 3. Lägger till det i listan
                // 4. Sparar till UserDefaults
                trailing: Button("Spara") {
                    let nyttRecept = Recipe(              // ← 2. Skapar nytt recept
                        id: UUID(),
                        title: title,
                        author: author,
                        description: description
                    )
                    
                    recipes.append(nyttRecept)            /* ← 3. Funktionen append(...) lägger till ett nytt element sist i en array.Den tar objektet nyttRecept, och lägger det längst ner i listan recipes */
                    sparaFunktion()                       // ← 4. Sparar till UserDefaults
                    dismiss()                             // ← Stänger formuläret
                }
                // Spara-knappen är inaktiverad om något fält är tomt
                .disabled(title.isEmpty || author.isEmpty || description.isEmpty)
            )
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
    @Binding var recipes: [Recipe]
    let recipe: Recipe

    @State private var visaRedigeraFormulär = false

    
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Redigera") {
                    visaRedigeraFormulär = true
                }
            }
        }
        .sheet(isPresented: $visaRedigeraFormulär) {
            RedigeraReceptFormulär(
                recipes: $recipes,
                receptAttRedigera: recipe
            )
        }

    }
}

struct RedigeraReceptFormulär: View {
    @Environment(\.dismiss) var dismiss

    @Binding var recipes: [Recipe]
    var receptAttRedigera: Recipe

    @State private var title: String
    @State private var author: String
    @State private var description: String

    init(recipes: Binding<[Recipe]>, receptAttRedigera: Recipe) {
        _recipes = recipes
        self.receptAttRedigera = receptAttRedigera
        _title = State(initialValue: receptAttRedigera.title)
        _author = State(initialValue: receptAttRedigera.author)
        _description = State(initialValue: receptAttRedigera.description)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Titel")) {
                    TextField("Ange titel", text: $title)
                }
                Section(header: Text("Författare")) {
                    TextField("Ange författare", text: $author)
                }
                Section(header: Text("Beskrivning")) {
                    TextField("Ange beskrivning", text: $description)
                }
            }
            .navigationTitle("Redigera Recept")
            .navigationBarItems(
                leading: Button("Avbryt") {
                    dismiss()
                },
                trailing: Button("Spara") {
                    if let index = recipes.firstIndex(where: { $0.id == receptAttRedigera.id }) {
                        recipes[index] = Recipe(
                            id: receptAttRedigera.id,
                            title: title,
                            author: author,
                            description: description
                        )
                        // Spara ändrad lista
                        let encoder = JSONEncoder()
                        if let encodedData = try? encoder.encode(recipes) {
                            UserDefaults.standard.set(encodedData, forKey: "sparadeRecept")
                        }
                    }
                    dismiss()
                }
                .disabled(title.isEmpty || author.isEmpty || description.isEmpty)
            )
        }
    }
}



#Preview {
    ContentView()
}
