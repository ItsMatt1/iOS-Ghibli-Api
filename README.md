# iOS Ghibli API - Desafio Técnico

Aplicativo iOS desenvolvido em SwiftUI que consome a Studio Ghibli API para exibir uma lista de filmes e seus detalhes.

## 📋 Requisitos Atendidos

### Escopo Mínimo (Obrigatório) ✅

- ✅ **Tela de lista de filmes**: Exibe título e ano de lançamento
- ✅ **Tela de detalhes do filme**: Mostra título, descrição, diretor, produtor e ano de lançamento
- ✅ **Networking**: Consumo da API com tratamento de estados de carregamento e erro
- ✅ **App funcional**: Compila e roda corretamente

### Extras Implementados 🎯

- ✅ **Swift 6**: Projeto migrado para Swift 6 com Approachable Concurrency
- ✅ **Default Actor Isolation**: Uso de isolamento padrão de actors do Swift 6
- ✅ **Actor para Networking**: `GhibliAPIService` implementado como `actor` para segurança de concorrência
- ✅ **Arquitetura**: Separação clara de responsabilidades (View / ViewModel / Service / Model)
- ✅ **Async/Await**: Uso de async/await para operações assíncronas
- ✅ **Tratamento de erros**: Enum `APIError` com mensagens localizadas
- ✅ **Estados de UI**: Loading, loaded e error states bem definidos
- ✅ **Imagens**: Suporte para exibir banners e thumbnails dos filmes (`movie_banner` e `image`)
- ✅ **AsyncImageView**: Componente reutilizável para carregamento assíncrono de imagens
- ✅ **Cache de Imagens**: Cache em memória usando `NSCache` para melhorar performance
- ✅ **Skeleton Loading**: Animações de skeleton para melhorar feedback visual durante carregamento
- ✅ **Busca/Filtro**: Campo de busca para filtrar filmes por título, diretor ou ano
- ✅ **Pull-to-Refresh**: Atualização da lista puxando para baixo

## 🏗️ Arquitetura

O projeto segue uma arquitetura MVVM (Model-View-ViewModel) com separação clara de responsabilidades:

### Estrutura de Pastas

```
GhibliMoviesApp/
├── Models/
│   └── Film.swift              # Modelo de dados do filme
├── Services/
│   ├── GhibliAPIService.swift  # Serviço de networking
│   └── ImageCache.swift        # Cache de imagens em memória
├── ViewModels/
│   ├── FilmListViewModel.swift # ViewModel da lista
│   └── FilmDetailViewModel.swift # ViewModel dos detalhes
├── Views/
│   ├── FilmListView.swift      # Tela de lista
│   ├── FilmDetailView.swift    # Tela de detalhes
│   ├── AsyncImageView.swift   # Componente para carregar imagens assincronamente
│   └── SkeletonView.swift     # Componente de skeleton loading
└── ContentView.swift           # Entry point da aplicação
```

### Componentes

1. **Models**: Estruturas de dados que representam as entidades da API
2. **Services**: Camada de networking implementada como `actor` para segurança de concorrência
3. **ViewModels**: Lógica de negócio e gerenciamento de estado usando `@Published` com Default Actor Isolation (Swift 6)
4. **Views**: Interface do usuário construída com SwiftUI

### Fluxo de Dados

```
View → ViewModel → Service → API
  ↑                              ↓
  └─────────── State ←───────────┘
```

- A View observa o estado do ViewModel através de `@StateObject`
- O ViewModel chama o Service para buscar dados
- O Service faz requisições HTTP e retorna os dados ou erros
- O ViewModel atualiza seu estado, que é refletido automaticamente na View

## 🚀 Como Executar

1. Abra o projeto no Xcode:
   ```bash
   open GhibliMoviesApp/GhibliMoviesApp.xcodeproj
   ```

2. Selecione um simulador ou dispositivo iOS (iOS 18.5+)

3. Execute o projeto (⌘ + R)

4. O app irá carregar automaticamente a lista de filmes da API

## 🔧 Tecnologias Utilizadas

- **SwiftUI**: Framework de UI declarativa
- **Swift 6.0**: Linguagem de programação com Approachable Concurrency
- **Actors**: Para isolamento seguro de concorrência
- **Async/Await**: Para operações assíncronas
- **URLSession**: Para requisições HTTP
- **Codable**: Para decodificação de JSON

## 📱 Funcionalidades

### Tela de Lista
- Lista todos os filmes do Studio Ghibli
- **Barra de busca** para filtrar filmes em tempo real
- Exibe thumbnail do filme (80x120)
- Exibe título e ano de lançamento
- Layout horizontal com imagem e informações
- Navegação para tela de detalhes ao tocar em um filme
- Estados de loading e erro com opção de retry
- Skeleton loading durante carregamento inicial
- Pull-to-refresh para atualizar a lista de filmes

### Tela de Detalhes
- Banner do filme no topo (usa `movie_banner` ou `image`)
- Exibe informações completas do filme:
  - Título
  - Ano de lançamento
  - Diretor
  - Produtor
  - Descrição completa
- Estados de loading e erro com opção de retry

## 🎨 Decisões Técnicas

### 1. Swift 6 e Approachable Concurrency
O projeto utiliza Swift 6 com as novas features de concorrência:
- **Default Actor Isolation**: `ObservableObject` automaticamente isola no `MainActor`, eliminando a necessidade de `@MainActor` explícito nos ViewModels
- **Actor para Networking**: `GhibliAPIService` é implementado como `actor`, garantindo isolamento seguro de concorrência para operações de rede
- **Approachable Concurrency**: Código mais seguro e fácil de entender, com verificação de concorrência em tempo de compilação

### 2. Enum `ViewState<T>`
Criado um enum genérico para representar os estados possíveis de uma view (loading, loaded, error), facilitando o tratamento e tornando o código mais limpo e reutilizável.

### 3. Enum `APIError`
Erros customizados com mensagens localizadas em português, melhorando a experiência do usuário.

### 4. AsyncImageView Component
Componente reutilizável para carregamento assíncrono de imagens:
- Carrega imagens de URL de forma assíncrona sem bloquear a UI
- Exibe skeleton loading animado enquanto carrega
- Trata erros de carregamento graciosamente
- Compatível com Swift 6 usando `@MainActor` para atualizações de UI
- Integrado com `ImageCache` para cache em memória

### 5. SkeletonView Component
Componente de skeleton loading para melhorar feedback visual:
- Animação de shimmer para indicar carregamento
- Componentes reutilizáveis: `SkeletonView`, `SkeletonImageView`, `SkeletonText`
- Usado na lista de filmes durante carregamento inicial
- Usado no `AsyncImageView` enquanto imagens carregam
- Melhora a percepção de performance e UX

### 6. ImageCache
Cache de imagens implementado como `actor` para thread-safety:
- Usa `NSCache` para armazenamento em memória
- Limite de 100 imagens ou 50 MB de memória
- Verifica cache antes de fazer requisições de rede
- Melhora significativamente a performance ao reutilizar imagens

### 7. Busca e Filtro
Funcionalidade de busca implementada no `FilmListViewModel`:
- Busca em tempo real conforme o usuário digita
- Filtro case-insensitive por múltiplos campos:
  - Título do filme
  - Título original
  - Diretor
  - Ano de lançamento
- Interface com `SearchBar` customizada
- Feedback visual quando não há resultados

### 8. Pull-to-Refresh
Funcionalidade nativa do SwiftUI para atualizar dados:
- Usa o modifier `.refreshable` do SwiftUI
- Mantém a lista visível durante o refresh (não mostra skeleton)
- Atualiza os filmes sem perder o estado atual
- Experiência nativa e familiar para usuários iOS

### 9. Separação de Responsabilidades
- **Service (Actor)**: Networking isolado em um actor, garantindo thread-safety
- **ViewModel**: Gerencia estado e coordena chamadas ao service, com isolamento automático no MainActor
- **View**: Apenas apresentação, sem lógica
- **Components**: Componentes reutilizáveis como `AsyncImageView` e `SearchBar` para funcionalidades comuns

## 🔮 O que faria diferente com mais tempo

1. **Cache de Dados**: Implementar cache para os dados dos filmes (não apenas imagens)
2. **Testes**: Adicionar testes unitários para ViewModels e Service
3. **UI/UX**: 
   - Melhorar hierarquia visual e layout
4. **Acessibilidade**: Adicionar labels e hints para VoiceOver
5. **Localização**: Suportar múltiplos idiomas
6. **Persistência**: Salvar filmes favoritos localmente

## 📚 API Utilizada

- **Base URL**: `https://ghibliapi.vercel.app`
- **Endpoints**:
  - `GET /films` - Lista todos os filmes
  - `GET /films/{id}` - Detalhes de um filme específico

## 📝 Notas

- O projeto usa file system synchronization, então novos arquivos são automaticamente adicionados ao projeto
- Requer iOS 18.5+ (conforme configuração do projeto)
- Não requer dependências externas (apenas frameworks nativos do iOS)
