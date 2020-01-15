<template>
  <div id="article-list">
    <ul>
      <li v-for="article in articles" v-bind:key="article.id">
        <div>{{article.title}}</div>
        <div>{{article.content}}</div>
      </li>
    </ul>
  </div>
</template>

<style lang="scss" scoped>
.article-list {
  height: 100%;
}
</style>

<script lang="ts">
  import axios from "axios"
  import { Vue, Component } from "vue-property-decorator"

  @Component
  export default class ArticleList extends Vue {
    articles: String[] = []

    async mounted(): Promise<void> {
      await this.fetchArticles();
    }

    async fetchArticles(): Promise<void> {
      await axios.get("/api/v1/articles").then((response) => {
        response.data.map((article: any) => {
          this.articles.push(article);
        })
      })
    }
  }
</script>