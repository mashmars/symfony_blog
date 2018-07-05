<?php
/**
 * Created by PhpStorm.
 * User: mash
 * Date: 2018/7/5
 * Time: 9:26
 */
namespace App\Controller;


use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\Routing\Annotation\Route;
use App\Entity\Article;
use App\Entity\Category;
use App\Entity\Tag;

class Blog extends Controller
{
    /**
     * @Route("/{page}",name="home",requirements={"page":"\d+"})
     */
    public function index($page=1)
    {
        $list = 6;
        $repository = $this->getDoctrine()->getRepository(Article::class);
        $query_builder = $repository->createQueryBuilder('u')->orderBy('u.id','DESC');

        $paginator = $this->get('knp_paginator');
        $pagination = $paginator->paginate($query_builder,$page,$list);
        return $this->render('index.html.twig',['pagination'=>$pagination]);
    }
    /**
     * @Route("/{id}/show",name="blog_show",requirements={"id":"\d+"})
     */
    public function show(Article $article)
    {
        $id = $article->getId();
        $repository = $this->getDoctrine()->getRepository(Article::class);
        //prev
        $prev = $repository->findOnePrevArticle($id);
        //next
        $next = $repository->findOneNextArticle($id);
        return $this->render('post-detail.html.twig',
            ['article'=>$article,'prev'=>$prev,'next'=>$next]
        );
    }
    /**
     * @Route("/category/{name}/{page}",name="blog_category",requirements={"page":"\d+"})
     * @根据分类名称查找文章
     */
    public function category($name,$page=1)
    {
        $list = 6;
        $entityManager = $this->getDoctrine()->getManager();
        $repository_c = $entityManager->getRepository(Category::class);
        $category = $repository_c->findOneBy(['name'=>$name]);

        $repository_a = $entityManager->getRepository(Article::class);
        $query_builder = $repository_a->createQueryBuilder('u')
            ->andWhere('u.category = :category')
            ->setParameter('category',$category)
            ->orderBy('u.id','DESC');

        $paginator = $this->get('knp_paginator');
        $pagination = $paginator->paginate($query_builder,$page,$list);
        return $this->render('index.html.twig',['pagination'=>$pagination]);
    }
    /**
     * @Route("/tag/{name}/{page}",name="blog_tag",requirements={"page":"\d+"})
     */
    public function tag($name,$page=1)
    {
        $list = 6;
        $entityManager = $this->getDoctrine()->getManager();

        $repository_a = $entityManager->getRepository(Article::class);
        $query_builder = $repository_a->dd($name);

        $paginator = $this->get('knp_paginator');
        $pagination = $paginator->paginate($query_builder,$page,$list);

        return $this->render('index.html.twig',['pagination'=>$pagination]);
    }

    /**
     * 右侧
     */
    public function right()
    {
        $repository = $this->getDoctrine()->getManager()->getRepository(Article::class);
        //最新的10篇文章
        $lastest = $repository->getLastest(10);
        //分类及汇总数
        $categorys = $this->getDoctrine()->getRepository(Category::class)->findAll();
        //标签
        $tags = $this->getDoctrine()->getRepository(Tag::class)->findAll();
        //按月份归档 从2018.07月开始

        return $this->render('right.html.twig',[
            'lastest'   =>  $lastest,
            'categorys' =>  $categorys,
            'tags'      =>  $tags,

        ]);
    }


    /**
     * @Route("/about",name="about")
     */
    public function about()
    {
        return $this->render('about.html.twig');
    }
    /**
     * @Route("/archive",name="archive")
     */
    public function archive()
    {
        return $this->render('archive.html.twig');
    }
}