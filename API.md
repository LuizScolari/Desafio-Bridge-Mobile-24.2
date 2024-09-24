# Beat API

Endereço base: https://caio-musicplayer.builtwithdark.com/

# Tipos

### Track

Atributos:

```
id: String
name: String
durationSeconds: Int
previewUrl: String (URL para um trecho da música)
album: Album
artists: List<Artist>
```

Exemplo: https://caio-musicplayer.builtwithdark.com/tracks/6U0FIYXCQ3TGrk4tFpLrEA

```json
{
  "album": {
    "id": "1jToVugwBEzcak8gJNZG2f",
    "image": "https://i.scdn.co/image/ab67616d0000b27346f07fa4f28bf824840ddacb",
    "name": "GINGER"
  },
  "artists": [
    {
      "id": "1Bl6wpkWCQ4KVgnASpvzzA",
      "name": "BROCKHAMPTON"
    }
  ],
  "durationSeconds": 204,
  "id": "6U0FIYXCQ3TGrk4tFpLrEA",
  "name": "SUGAR",
  "previewUrl": "https://p.scdn.co/mp3-preview/5ede99e4306c75ac7b99f277807fb91c2ce5c785?cid=e197ecf670a44f22bc5c05085e8d35e2"
}
```

### Album

Atributos:

```
id: String
name: String
image: String (URL para a imagem de capa do álbum)
```

Exemplo: https://caio-musicplayer.builtwithdark.com/tracks/5dTHtzHFPyi8TlTtzoz1J9

```json
"album": {
  "id": "3DuiGV3J09SUhvp8gqNx8h",
  "image": "https://i.scdn.co/image/ab67616d0000b273cab7ae4868e9f9ce6bdfdf43",
  "name": "Three Cheers for Sweet Revenge"
}
```

### Artist

Atributos:

```
id: String
name: String
```

Exemplo: https://caio-musicplayer.builtwithdark.com/tracks/5ZdrNnYV5VZWds4WXKf8kf

```json
{
  "id": "74XFHRwlV6OrjEM0A2NCMF",
  "name": "Paramore"
}
```

### FullAlbum

Atributos (todos os atributos de Album e mais):

```
tracks: List<Track>
```

Exemplo: https://caio-musicplayer.builtwithdark.com/albums/3DuiGV3J09SUhvp8gqNx8h

### FullArtist

Atributos (todos os atributos de Artist e mais):

```
followers: Int
albums: List<FullAlbum> (Apenas os últimos 5 álbuns do artista)
top_tracks: List<Track>
```

Exemplo: https://caio-musicplayer.builtwithdark.com/albums/3DuiGV3J09SUhvp8gqNx8h

# Endpoints

## GET /tracks/[id]

Obtém uma Track a partir de seu ID.

#### Parâmetros:

`id`: ID de uma Track

#### Resposta

Objeto Track

## GET /artist/[id]

Obtém um Artist a partir de seu ID.

#### Parâmetros:

`id`: ID de um Artist

#### Resposta

Objeto FullArtist

## GET /album/[id]

Obtém um Album a partir de seu ID.

#### Parâmetros:

`id`: ID de um Album

#### Resposta

Objeto FullAlbum

## GET /top

Obtém as 50 músicas mais tocadas

#### Parâmetros:

Nenhum

#### Resposta

Lista de Track

## GET /search?q=[query]

Obtém as 50 músicas mais tocadas

#### Parâmetros:

`query`: String que deve ser buscada

#### Resposta

Lista de Track

#### Exemplo

https://caio-musicplayer.builtwithdark.com/search?q=paramore

## GET /favorites?email=[email]

Obtém as músicas favoritas de um usuário

#### Parâmetros:

`email`: Email do usuário

#### Resposta

Lista de Track

## POST /favorites/add/[id]?email=[email]

Adiciona música na lista de favoritos de um usuário

#### Parâmetros:

`id`: ID da Track
`email`: Email do usuário

#### Resposta

Lista de Track (lista de favoritos atualizada)

## POST /favorites/remove/[id]?email=[email]

Adiciona música na lista de favoritos de um usuário

#### Parâmetros:

`id`: ID da Track
`email`: Email do usuário

#### Resposta

Lista de Track (lista de favoritos atualizada)

## POST /favorites/clear?email=[email]

Adiciona música na lista de favoritos de um usuário

#### Parâmetros:

`id`: ID da Track
`email`: Email do usuário

#### Resposta

Lista de Track (lista de favoritos atualizada)
