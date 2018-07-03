<?php
/**
 * Created by PhpStorm.
 * User: mash
 * Date: 2018/7/3
 * Time: 11:31
 */
namespace App\Controller\Admin;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;
use App\Entity\Article as ArticleEntity;
use App\Form\ArticleType;

/**
 * Class Article
 * @package App\Controller\Admin
 * @Route("/admin/article")
 */
class Article extends Controller
{
    /**
     * @Route("/index",name="article_index")
     */
    public function index()
    {
        $repository = $this->getDoctrine()->getRepository(ArticleEntity::class);
        $res = $repository->findAll();
        return $this->render('admin/article/index.html.twig',[
            'res'   =>  $res,
        ]);
    }

    /**
     * @Route("/add",name="article_add" , methods={"GET","POST"})
     */
    public function add(Request $request)
    {
        $article = new ArticleEntity();
        $form = $this->createForm(ArticleType::class,$article);
        $form->handleRequest($request);
        if($form->isSubmitted() && $form->isValid()){
            $article = $form->getData();
            $entityManager = $this->getDoctrine()->getManager();
            $entityManager->persist($article);
            $entityManager->flush();
            return $this->redirectToRoute('article_index');
        }

        return $this->render('admin/article/add.html.twig',
            ['form'=>$form->createView()]);
    }

}